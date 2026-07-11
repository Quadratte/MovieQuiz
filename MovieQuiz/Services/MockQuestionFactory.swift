import UIKit

final class MockQuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?

    private let mockQuestions: [QuizQuestion] = [
        QuizQuestion(
            image: UIImage(named: "The Godfather")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "The Dark Knight")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "Kill Bill")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "The Avengers")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "Deadpool")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "The Green Knight")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: UIImage(named: "Old")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: UIImage(named: "The Ice Age Adventures of Buck Wild")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: UIImage(named: "Tesla")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: UIImage(named: "Vivarium")?.pngData() ?? Data(),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        )
    ]

    private var currentIndex = 0

    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }

    func loadData() {
        delegate?.didLoadDataFromServer()
    }

    func requestNextQuestion() {
        guard currentIndex < mockQuestions.count else {
            currentIndex = 0
            delegate?.didReceiveNextQuestion(question: mockQuestions[currentIndex])
            return
        }

        let question = mockQuestions[currentIndex]
        currentIndex += 1

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didReceiveNextQuestion(question: question)
        }
    }
}
