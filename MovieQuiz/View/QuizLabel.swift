import UIKit

final class QuizLabel: UILabel {

    enum QuizLabelStyles {
        case heading
        case regular
    }

    private let labelTitle: String
    private let quizLabelStyle: QuizLabelStyles
    private let identifier: String?

    init(_ labelTitle: String, _ quizLabelStyle: QuizLabelStyles, identifier: String? = nil) {
        self.labelTitle = labelTitle
        self.quizLabelStyle = quizLabelStyle
        self.identifier = identifier
        super.init(frame: .zero)
        setupQuizLabel()
        applyQuizLabelStyles()
        setupAccessibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupQuizLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelTitle
        numberOfLines = 2
        textColor = UIColor.ypWhite
        textAlignment = .center
    }

    private func applyQuizLabelStyles() {
        switch quizLabelStyle {
        case .heading:
            font = UIFont(name: "YSDisplay-Bold", size: 23)
        case .regular:
            font = UIFont(name: "YSDisplay-Medium", size: 20)
        }
    }

    private func setupAccessibility() {
        if let identifier {
            accessibilityIdentifier = identifier
        }
    }
}
