import UIKit

final class QuizLabel: UILabel {

    enum QuizLabelStyles {
        case heading
        case regular
    }

    private let labelTitle: String
    private let QuizLabelStyle: QuizLabelStyles

    init(_ labelTitle: String, _ QuizLabelStyle: QuizLabelStyles) {
        self.labelTitle = labelTitle
        self.QuizLabelStyle = QuizLabelStyle
        super.init(frame: .zero)
        setupQuizLabel()
        applyQuizLabelStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupQuizLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelTitle
        numberOfLines = 2
        textColor = .ypWhite
        textAlignment = .center
    }

    private func applyQuizLabelStyles() {
        switch QuizLabelStyle {
        case .heading:
            font = UIFont(name: "YSDisplay-Bold", size: 23)
        case .regular:
            font = UIFont(name: "YSDisplay-Medium", size: 20)
        }
    }
}
