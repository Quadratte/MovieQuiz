import UIKit

final class MovieQuizViewController: UIViewController {

    private let questions = QuizQuestion.mockQuestions
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    // DRY, но не стал выносить стеки в отдельный компонент, т.к. один экран.
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
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    private let titleLabel = AppLabel("Вопрос:", .regular)
    private let progressLabel = AppLabel("1/10", .regular)
    private let moviePosterImage = AppImageView(" ")
    private let questionLabel = AppLabel("Рейтинг этого фильма меньше чем 5?", .heding)
    private let yesButton = AppButton("Yes")
    private let noButton = AppButton("No")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .ypBlack

        view.addSubview(mainStack)

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(moviePosterImage)
        mainStack.addArrangedSubview(questionLabel)
        mainStack.addArrangedSubview(buttonStack)

        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(progressLabel)

        buttonStack.addArrangedSubview(yesButton)
        buttonStack.addArrangedSubview(noButton)
    }

    private func setupActions() {

        yesButton.addAction(UIAction { [weak self] _ in
            self?.updateUI()
        }, for: .touchUpInside)

        noButton.addAction(UIAction { [weak self] _ in
        }, for: .touchUpInside)
    }

    private func updateUI() {
        show(quiz: convert(model: questions[currentQuestionIndex]))
        currentQuestionIndex += 1
        showAnswerResult(isCorrect: isAnswerCorrect())
        print("Yes +1")
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )

        return questionStep
    }

    private func show(quiz step: QuizStepViewModel) {
        progressLabel.text = step.questionNumber
        moviePosterImage.image = step.image
        questionLabel.text = step.question
    }

    private func isAnswerCorrect() -> Bool {
        let ans = Bool.random()
        return ans
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            moviePosterImage.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            moviePosterImage.layer.borderColor = UIColor.ypRed.cgColor
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            moviePosterImage.widthAnchor.constraint(equalTo: moviePosterImage.heightAnchor, multiplier: 2/3),
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
