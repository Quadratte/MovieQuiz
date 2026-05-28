import UIKit

final class AppImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.systemGreen.cgColor
        backgroundColor = .white
        image = .deadpool
        contentMode = .scaleAspectFill
    }
}
