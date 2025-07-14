import UIKit

extension UIViewController {
    func showAlert(title: String = "Error!", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showDeleteAlert(for contact: Contact, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Delete Contact",
            message: "Are you sure you want to delete this contact?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            onConfirm()
        })
        
        present(alert, animated: true)
    }
    
    func presentSortOptions(onOptionSelected: @escaping (SortOption) -> Void) {
        let alert = UIAlertController(
            title: "Sort Contacts ⚙️",
            message: "Select sorting option",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "By Name", style: .default, handler: { _ in
            onOptionSelected(.name)
        }))
        
        alert.addAction(UIAlertAction(title: "By Date Edited", style: .default, handler: { _ in
            onOptionSelected(.date)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
}
