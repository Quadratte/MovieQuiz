import UIKit

struct AlertPresenter {

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func show(model: AlertModel, identifier: String? = nil) {
        guard let viewController else { return }

        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )

        if let identifier {
            alert.view.accessibilityIdentifier = identifier
        }

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)

        viewController.present(alert, animated: true)
    }
}
