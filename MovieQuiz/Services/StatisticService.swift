import Foundation

final class StatisticService {

    private let storage = UserDefaults.standard

    private enum Keys {
        static let gamesCount = "gamesCount"
        static let bestGameCorrect = "bestGameCorrect"
        static let bestGameTotal = "bestGameTotal"
        static let bestGameDate = "bestGameDate"
        static let totalCorrect = "totalCorrect"
        static let totalQuestions = "totalQuestions"
    }
}

extension StatisticService: StatisticServiceProtocol {

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount)
        } set {
            storage.set(newValue, forKey: Keys.gamesCount)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect)
            let total = storage.integer(forKey: Keys.bestGameTotal)
            let date = storage.object(forKey: Keys.bestGameDate) as? Date ?? Date()

            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect)
            storage.set(newValue.total, forKey: Keys.bestGameTotal)
            storage.set(newValue.date, forKey: Keys.bestGameDate)
        }
    }

    var totalAccuracy: Double {
        let totalCorrect = storage.integer(forKey: Keys.totalCorrect)
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions)

        guard totalQuestions > 0 else { return 0 }

        return Double(totalCorrect) / Double(totalQuestions) * 100
    }

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1

        let totalCorrect = storage.integer(forKey: Keys.totalCorrect)
        storage.set(totalCorrect + count, forKey: Keys.totalCorrect)

        let totalQuestions = storage.integer(forKey: Keys.totalQuestions)
        storage.set(totalQuestions + amount, forKey: Keys.totalQuestions)

        let currentResult = GameResult(correct: count, total: amount, date: Date())

        if currentResult.isBetterThan(another: bestGame) {
            bestGame = currentResult
        }
    }
}
