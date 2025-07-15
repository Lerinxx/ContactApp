import UIKit

extension UIViewController {
    func showAlert(title: String = Constants.errorTitle, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
        present(alert, animated: true)
    }
    
    func showDeleteAlert(for contact: Contact, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: Constants.deleteContactTitle,
            message: Constants.deleteMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: Constants.deleteTitle, style: .destructive) { _ in
            onConfirm()
        })
        
        present(alert, animated: true)
    }
    
    func presentSortOptions(onOptionSelected: @escaping (SortOption) -> Void) {
        let alert = UIAlertController(
            title: Constants.sortTitle,
            message: Constants.sortMessage,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: Constants.byNameTitle, style: .default, handler: { _ in
            onOptionSelected(.name)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.byDateTitle, style: .default, handler: { _ in
            onOptionSelected(.date)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel))
        
        present(alert, animated: true)
    }
    
}
