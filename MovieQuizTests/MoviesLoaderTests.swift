import XCTest
@testable import MovieQuiz

final class MoviesLoaderTest: XCTestCase {

    func testSuccessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 10)
    }

    func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Failure loading expectation")

        loader.loadMovies { result in
            switch result {
            case .failure(let failure):
                XCTAssertNotNil(failure)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
