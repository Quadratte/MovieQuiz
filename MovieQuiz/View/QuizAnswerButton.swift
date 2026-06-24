import UIKit

final class QuizAnswerButton: UIButton {

    private let buttonTitle: String

    init(_ buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        setupQuizButton()
        applyQuizButtonStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupQuizButton() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = 15
    }

    private func applyQuizButtonStyles() {
        backgroundColor = UIColor.ypWhite
        setTitleColor(UIColor.ypBlack, for: .normal)
    }
}
