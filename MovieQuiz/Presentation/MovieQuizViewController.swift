import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

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
    private let progressLabel = QuizLabel("1/10", .regular, identifier: "Index")
    private let moviePosterImage = MoviePosterImageView(identifier: "Poster")
    private let questionLabel = QuizLabel("Рейтинг этого фильма больше чем 6?", .heading)
    private let yesButton = QuizAnswerButton("Да")
    private let noButton = QuizAnswerButton("Нет")
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.alpha = 1.0
        indicator.hidesWhenStopped = true
        indicator.color = .ypWhite
        return indicator
    }()

    // MARK: - Properties

        showLoadingIndicator()
        questionsFactory.loadData()
    }

    // MARK: - Actions

    private func handleAnswer(isYes: Bool) {
        setButtons(isEnabled: false)
        presenter.handleAnswer(isYes: isYes)
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

        moviePosterImage.addSubview(indicator)
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
            indicator.centerYAnchor.constraint(equalTo: moviePosterImage.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: moviePosterImage.centerXAnchor),
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

    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionsFactory.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            let userMessage = ErrorHandler.getUserFriendlyMessage(from: error)
            self?.showNetworkError(message: userMessage)
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
        showLoadingIndicator()
        questionsFactory.loadData()
    }

    // MARK: - Mapping

    private func convert(model: QuizQuestion) -> QuizStepModel {
        return QuizStepModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    // MARK: - Presentation

    func show(quiz step: QuizStepModel) {
        progressLabel.text = step.questionNumber
        questionLabel.text = step.question
        moviePosterImage.layer.borderColor = UIColor.clear.cgColor


        moviePosterImage.image = step.image
    }

    func showResults() {
        let message = """
        Ваш результат: \(presenter.correctAnswers) из \(presenter.questionsAmount)
        Количество сыгранных квизов: \(presenter.statisticService.gamesCount)
        Рекорд: \(presenter.statisticService.bestGame.correct) из \(presenter.statisticService.bestGame.total) (\(presenter.statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", presenter.statisticService.totalAccuracy))%
        """

        let alertModel = AlertModel(
            title: "Игра окончена",
            message: message,
            buttonText: "Сыграть еще раз"
        ) { [weak self] in
            self?.presenter.resetGame()
        }

        alertPresenter.show(model: alertModel, identifier: "QuizResultAlert")
    }

    func showLoadingIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }

    func hideLoadingIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            self?.presenter.resetGame()
        }
        alertPresenter.show(model: alertModel)
    }
  
    private func showLoadingIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                self?.resetGame()
            }
        alertPresenter.show(model: alertModel)
    }

    // MARK: - Helpers
    
    private func isAnswerCorrect() -> Bool {
        currentQuestion?.correctAnswer ?? false
    }

    // MARK: - Helpers

    func setButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
}
