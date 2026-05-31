import UIKit

final class AppImageView: UIImageView {

    private let posterImage: String

    init(_ posterImage: String) {
        self.posterImage = posterImage
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
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .white
        image = UIImage(named: posterImage)
        contentMode = .scaleAspectFill
    }
}
