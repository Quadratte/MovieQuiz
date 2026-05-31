import UIKit

final class AppLabel: UILabel {

    enum AppLabelStyles {
        case heding
        case regular
    }

    private let labelTitle: String
    private let appLabelStyle: AppLabelStyles

    init(_ labelTitle: String, _ appLabelStyle: AppLabelStyles) {
        self.labelTitle = labelTitle
        self.appLabelStyle = appLabelStyle
        super.init(frame: .zero)
        setpAppLabel()
        applyAppLabelStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setpAppLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelTitle
        numberOfLines = 2
        textColor = .ypWhite
        textAlignment = .center
    }

    private func applyAppLabelStyles() {
        switch appLabelStyle {
        case .heding:
            font = UIFont(name: "YSDisplay-Bold", size: 23)
        case .regular:
            font = UIFont(name: "YSDisplay-Medium", size: 20)
        }
    }
}
