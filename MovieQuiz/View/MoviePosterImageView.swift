import UIKit

final class MoviePosterImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        setupMoviePosterImageViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMoviePosterImageViewUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.borderWidth = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .white
        contentMode = .scaleAspectFill
    }
}
