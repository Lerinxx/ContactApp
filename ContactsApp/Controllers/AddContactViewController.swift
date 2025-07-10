import UIKit
import PhoneNumberKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

final class AddContactViewController: BaseContactViewController {
    weak var delegate: AddContactDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New contact"
        configNavigation()
    }
    
    private func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        guard let contact = getContactInfo() else {
            showAlert(message: "Failed to create contact")
            return
        }
        delegate?.didAddContact(contact)
        dismiss(animated: true)
    }
}
