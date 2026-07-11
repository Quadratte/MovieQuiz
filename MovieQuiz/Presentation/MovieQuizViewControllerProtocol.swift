import Foundation

protocol MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepModel)
    func showResults()
    func showAnswerResult(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func setButtons(isEnabled: Bool)
}
