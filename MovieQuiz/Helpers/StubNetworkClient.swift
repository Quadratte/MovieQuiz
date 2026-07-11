import Foundation

struct StubNetworkClient: NetworkRoutingProtocol {

    enum TestError: Error {
        case test
    }

    let emulateError: Bool

    func fetch(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }

    private var expectedResponse: Data {
        """
        {
            "errorMessage": "",
            "items": [
                {
                    "fullTitle": "Prey (2022)",
                    "imDbRating": "7.2",
                    "image": "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg"
                },
                {
                    "fullTitle": "The Gray Man (2022)",
                    "imDbRating": "6.5",
                    "image": "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg"
                }
            ]
        }
        """.data(using: .utf8) ?? Data()
    }
}
