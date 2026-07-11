import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() {
        sleep(3)

        let poster = app.images["Poster"]
        XCTAssertTrue(poster.waitForExistence(timeout: 10))

        let firstPosterData = poster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        let firstIndex = indexLabel.label

        app.buttons["Yes"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        let newIndex = indexLabel.label

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertNotEqual(firstIndex, newIndex)
        XCTAssertEqual(newIndex, "2/10")
    }

    func testNoButton() {
        sleep(3)

        let poster = app.images["Poster"]
        XCTAssertTrue(poster.waitForExistence(timeout: 10))

        let firstPosterData = poster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        let firstIndex = indexLabel.label

        app.buttons["No"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        let newIndex = indexLabel.label

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertNotEqual(firstIndex, newIndex)
        XCTAssertEqual(newIndex, "2/10")
    }

    func testAlertGameResult() {
        sleep(3)

        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["QuizResultAlert"]

        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertEqual(alert.label, "Игра окончена")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }

    func testAlertDismiss() {
        sleep(3)

        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["QuizResultAlert"]
        alert.buttons.firstMatch.tap()

        sleep(3)

        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
