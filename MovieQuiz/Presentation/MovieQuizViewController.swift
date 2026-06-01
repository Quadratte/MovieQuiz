/* NOTE: Делал без сторибордов, поэтому лаунчскрин сделал через plist.
         Так как там нет возможности вёрстки, то поставил лого + bgColor.
*/

import UIKit

final class MovieQuizViewController: UIViewController {

    private let questions = QuizQuestion.mockQuestions
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

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
    private let moviePosterImage = AppImageView()
    private let questionLabel = AppLabel("Рейтинг этого фильма больше чем 6?", .heding)
    private let yesButton = AppButton("Yes")
    private let noButton = AppButton("No")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
        updateUI()
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
            self?.handleAnswer(isYes: true)
        }, for: .touchUpInside)

        noButton.addAction(UIAction { [weak self] _ in
            self?.handleAnswer(isYes: false)
        }, for: .touchUpInside)
    }

    private func handleAnswer(isYes: Bool) {
        let isCorrect = isYes ? isAnswerCorrect() : !isAnswerCorrect()

        if isCorrect {
           correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
    }

    private func isAnswerCorrect() -> Bool {
        questions[currentQuestionIndex].correctAnswer
    }

    private func updateUI() {
        let step = convert(model: questions[currentQuestionIndex])
        show(quiz: step)
    }

    private func show(quiz step: QuizStepViewModel) {
        progressLabel.text = step.questionNumber
        moviePosterImage.image = step.image
        questionLabel.text = step.question
        moviePosterImage.layer.borderColor = UIColor.clear.cgColor
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }

    private func showAnswerResult(isCorrect: Bool) {
        let borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        moviePosterImage.layer.borderColor = borderColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            self?.moviePosterImage.layer.borderColor = UIColor.clear.cgColor
            self?.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            updateUI()
        } else {
            showResults()
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

    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        updateUI()
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
