import UIKit

final class AppButton: UIButton {

    private let buttonTitle: String

    init(_ buttonTitle: String) {
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        setupAppButton()
        applyAppButtonStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppButton() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = 16
    }

    private func applyAppButtonStyles() {
        backgroundColor = .white
        setTitleColor(.ypBlack, for: .normal)
    }
}
