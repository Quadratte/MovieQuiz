import UIKit

final class MoviePosterImageView: UIImageView {

    private let identifier: String

    init(identifier: String) {
        self.identifier = identifier
        super.init(frame: .zero)
        setupUI()
        setupAccessibility()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .ypBlack
        contentMode = .scaleAspectFill
    }

    private func setupAccessibility() {
        accessibilityIdentifier = identifier
    }
}
