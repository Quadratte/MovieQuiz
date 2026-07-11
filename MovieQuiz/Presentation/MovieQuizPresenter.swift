import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {

    // MARK: - Properties

    var view: MovieQuizViewControllerProtocol?

    private var questionsFactory: QuestionFactoryProtocol
    let statisticService: StatisticServiceProtocol

    private(set) var currentQuestionIndex = 0
    private(set) var correctAnswers = 0
    private(set) var currentQuestion: QuizQuestion?
    let questionsAmount = 10

    // MARK: - Init

    init(
        view: MovieQuizViewControllerProtocol? = nil,
        questionsFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: nil),
        statisticService: StatisticServiceProtocol = StatisticService()
    ) {
        self.view = view
        self.questionsFactory = questionsFactory
        self.statisticService = statisticService
        self.questionsFactory.delegate = self

        if QuestionFactoryConfig.useMockData {
                self.questionsFactory = MockQuestionFactory(delegate: self)
            } else {
                self.questionsFactory = QuestionFactory(
                    moviesLoader: MoviesLoader(),
                    delegate: self
                )
            }
    }

    // MARK: - Flow

    func loadData() {
        view?.showLoadingIndicator()
        questionsFactory.loadData()
    }

    func handleAnswer(isYes: Bool) {
        let isCorrect = isYes ? isAnswerCorrect() : !isAnswerCorrect()

        if isCorrect {
            correctAnswers += 1
        }
        view?.showAnswerResult(isCorrect: isCorrect)
    }

    func convert(model: QuizQuestion) -> QuizStepModel {
        return QuizStepModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    func showNextQuestionOrResults() {
        if currentQuestionIndex + 1 < questionsAmount {
            currentQuestionIndex += 1
            questionsFactory.requestNextQuestion()
        } else {
            view?.showResults()
        }
        view?.setButtons(isEnabled: true)
    }

    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        view?.showLoadingIndicator()
        questionsFactory.loadData()
    }

    private func isAnswerCorrect() -> Bool {
        currentQuestion?.correctAnswer ?? false
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question

        let model = convert(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.view?.show(quiz: model)
        }
    }

    func didLoadDataFromServer() {
        view?.hideLoadingIndicator()
        questionsFactory.requestNextQuestion()
    }

    func didFailToLoadData(with error: any Error) {
        DispatchQueue.main.async { [weak self] in
            let userMessage = ErrorHandler.getUserFriendlyMessage(from: error)
            self?.view?.showNetworkError(message: userMessage)
        }
    }

    // MARK: - Statistic
    
    func getStatisticMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        return """
        Ваш результат: \(correctAnswers) из \(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.correct) из \(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
    }
}
