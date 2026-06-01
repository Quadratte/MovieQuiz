import UIKit

public struct QuizQuestion {
    let image: String
    let actualRating: Double
    let text: String
    let correctAnswer: Bool

    static let mockQuestions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     actualRating: 9.2,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     actualRating: 9.2,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     actualRating: 8.1,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     actualRating: 8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     actualRating: 8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     actualRating: 6.6,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     actualRating: 5.8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Old",
                     actualRating: 4.3,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     actualRating: 5.1,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     actualRating: 5.8,
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
    ]
}
