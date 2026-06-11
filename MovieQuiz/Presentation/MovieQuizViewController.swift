import UIKit

final class MovieQuizViewController: UIViewController {

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

    private let questions = QuizQuestion.mockQuestions

    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
        updateUI()
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
        view.backgroundColor = .ypBlack
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

    // MARK: - Quiz Flow

    private func updateUI() {
        let step = convert(model: questions[currentQuestionIndex])
        show(quiz: step)
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            updateUI()
        } else {
            showResults()
        }
        setButtons(isEnabled: true, yesButton, noButton)
    }

    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        updateUI()
    }

    // MARK: - Mapping

    private func convert(model: QuizQuestion) -> QuizStepModel {
        return QuizStepModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            self?.moviePosterImage.layer.borderColor = UIColor.clear.cgColor
            self?.showNextQuestionOrResults()
        }
    }

    private func showResults() {
        let message = "Вы ответили правильно на \(correctAnswers) из \(questions.count) вопросов."
        let alert = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { [ weak self ] _ in
            
            self?.resetGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    // MARK: - Helpers

    private func isAnswerCorrect() -> Bool {
        return questions[currentQuestionIndex].correctAnswer
    }

    private func setButtons(isEnabled: Bool, _ buttons: UIButton...) {
        buttons.forEach { $0.isEnabled = isEnabled }
    }
}
