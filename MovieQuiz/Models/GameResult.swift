import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(another: GameResult) -> Bool {
        correct > another.correct
    }
}
