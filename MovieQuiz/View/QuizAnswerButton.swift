import UIKit

final class QuizAnswerButton: UIButton {

    private let buttonTitle: String
    private let identifier: String

    init(_ buttonTitle: String, identifier: String ) {
        self.buttonTitle = buttonTitle
        self.identifier = identifier
        super.init(frame: .zero)
        setupQuizButton()
        setupAccessibility()
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

    private func setupAccessibility() {
        accessibilityIdentifier = identifier
    }

    private func applyQuizButtonStyles() {
        backgroundColor = UIColor.ypWhite
        setTitleColor(UIColor.ypBlack, for: .normal)
    }
}
