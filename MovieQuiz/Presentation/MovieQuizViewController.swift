import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - UI Elements

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    private let titleLabel = QuizLabel("Вопрос:", .regular)
    private let progressLabel = QuizLabel("1/10", .regular)
    private let moviePosterImage = MoviePosterImageView()
    private let questionLabel = QuizLabel("Рейтинг этого фильма больше чем 6?", .heading)
    private let yesButton = QuizAnswerButton("Да")
    private let noButton = QuizAnswerButton("Нет")

    // MARK: - Properties

    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private lazy var questionsFactory = QuestionFactory(delegate: self)
    private lazy var alertPresenter = AlertPresenter(viewController: self)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
        questionsFactory.requestNextQuestion()
    }

    // MARK: - Actions

    private func handleAnswer(isYes: Bool) {
        setButtons(isEnabled: false, yesButton, noButton)

        let isCorrect = isYes ? isAnswerCorrect() : !isAnswerCorrect()

        if isCorrect {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(mainStack)

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(moviePosterImage)
        mainStack.addArrangedSubview(questionLabel)
        mainStack.addArrangedSubview(buttonsStack)

        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(progressLabel)

        buttonsStack.addArrangedSubview(yesButton)
        buttonsStack.addArrangedSubview(noButton)
    }

    private func setupActions() {
        yesButton.addAction(UIAction { [weak self] _ in
            self?.handleAnswer(isYes: true)
        }, for: .touchUpInside)

        noButton.addAction(UIAction { [weak self] _ in
            self?.handleAnswer(isYes: false)
        }, for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            headerStack.heightAnchor.constraint(equalToConstant: 24),
            moviePosterImage.widthAnchor.constraint(equalTo: moviePosterImage.heightAnchor, multiplier: 2/3),
            questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question

        let model = convert(model: question)

        DispatchQueue.main.async {
            self.show(quiz: model)
        }
    }

    // MARK: - Quiz Flow

    private func showNextQuestionOrResults() {
        if currentQuestionIndex + 1 < questionsAmount {
            currentQuestionIndex += 1
            questionsFactory.requestNextQuestion()
        } else {
            showResults()
        }
        setButtons(isEnabled: true, yesButton, noButton)
    }

    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionsFactory.requestNextQuestion()
    }

    // MARK: - Mapping

    private func convert(model: QuizQuestion) -> QuizStepModel {
        return QuizStepModel(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    // MARK: - Presentation

    private func show(quiz step: QuizStepModel) {
        progressLabel.text = step.questionNumber
        moviePosterImage.image = step.image
        questionLabel.text = step.question
        moviePosterImage.layer.borderColor = UIColor.clear.cgColor
    }

    private func showAnswerResult(isCorrect: Bool) {
        let borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        moviePosterImage.layer.borderColor = borderColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.moviePosterImage.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }

    private func showResults() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let message = """
                Ваш результат: \(correctAnswers) из \(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct) из \(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                """

        let alertModel = AlertModel(
            title: "Игра окончена",
            message: message,
            buttonText: "Сыграть еще раз"
        ) { [weak self] in
            self?.resetGame()
        }

        alertPresenter.show(model: alertModel)
    }

    // MARK: - Helpers

    private func isAnswerCorrect() -> Bool {
        currentQuestion?.correctAnswer ?? false
    }

    private func setButtons(isEnabled: Bool, _ buttons: UIButton...) {
        buttons.forEach { $0.isEnabled = isEnabled }
    }
}
