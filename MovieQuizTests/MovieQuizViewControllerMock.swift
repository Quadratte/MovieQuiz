import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepModel) {

    }

    func showResults() {

    }

    func showAnswerResult(isCorrect: Bool) {

    }

    func showLoadingIndicator() {

    }

    func hideLoadingIndicator() {

    }

    func showNetworkError(message: String) {

    }

    func setButtons(isEnabled: Bool) {

    }

}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(view: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

