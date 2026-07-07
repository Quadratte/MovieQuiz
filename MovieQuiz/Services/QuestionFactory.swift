import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?

    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoadingProtocol

    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            let index = (0..<movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }

            let rating = Float(movie.rating) ?? 0

            let text = "Рейтинг этого фильма больше чем 7?"

            let correctAnswer = rating > 7

            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
//    private let mockQuestions: [QuizQuestion] = [
//        QuizQuestion(imageName: "The Godfather",
//                     actualRating: 9.2,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "The Dark Knight",
//                     actualRating: 9.2,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "Kill Bill",
//                     actualRating: 8.1,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "The Avengers",
//                     actualRating: 8,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "Deadpool",
//                     actualRating: 8,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "The Green Knight",
//                     actualRating: 6.6,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: true),
//        QuizQuestion(imageName: "The Ice Age Adventures of Buck Wild",
//                     actualRating: 5.8,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(imageName: "Old",
//                     actualRating: 4.3,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(imageName: "Tesla",
//                     actualRating: 5.1,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//        QuizQuestion(imageName: "Vivarium",
//                     actualRating: 5.8,
//                     text: "Рейтинг этого фильма больше чем 6?",
//                     correctAnswer: false),
//    ]
//}

