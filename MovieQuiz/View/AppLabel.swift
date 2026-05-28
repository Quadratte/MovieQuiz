import UIKit

final class AppLabel: UILabel {

    private let labelTitle: String

    init(_ labelTitle: String) {
        self.labelTitle = labelTitle
        super.init(frame: .zero)
        setpAppLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setpAppLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelTitle
        numberOfLines = 0
        font = UIFont(name: "YSDisplay-Bold", size: 32)
        textColor = .white
        textAlignment = .center
    }
}
