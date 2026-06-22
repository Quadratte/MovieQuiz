import Foundation

final class QuestionFactory: QuestionFactoryProtocol {

    weak var delegate: QuestionFactoryDelegate?

    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }

    func requestNextQuestion() {
        guard let index = (0..<mockQuestions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = mockQuestions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }

    private let mockQuestions: [QuizQuestion] = [
        QuizQuestion(imageName: "The Godfather",
                     actualRating: 9.2,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "The Dark Knight",
                     actualRating: 9.2,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "Kill Bill",
                     actualRating: 8.1,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "The Avengers",
                     actualRating: 8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "Deadpool",
                     actualRating: 8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "The Green Knight",
                     actualRating: 6.6,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(imageName: "The Ice Age Adventures of Buck Wild",
                     actualRating: 5.8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageName: "Old",
                     actualRating: 4.3,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageName: "Tesla",
                     actualRating: 5.1,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(imageName: "Vivarium",
                     actualRating: 5.8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
    ]
}
