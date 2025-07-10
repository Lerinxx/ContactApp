import UIKit
import PhoneNumberKit

protocol EditContactDelegate: AnyObject {
    func didUpdateContact(_ contact: Contact)
    func didDeleteContact(_ contact: Contact)
}

final class EditContactViewController: BaseContactViewController {
    weak var delegate: EditContactDelegate?
    private var contact: Contact
    
    private let deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Delete Contact", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit contact"
        configUI()
        configNavigation()
        configForm()
    }
    
    private func configUI() {
        formView.addSubview(deleteBtn)
        
        NSLayoutConstraint.activate([
            deleteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteBtn.heightAnchor.constraint(equalToConstant: 50),
            deleteBtn.topAnchor.constraint(equalTo: formView.phoneField.bottomAnchor, constant: 20)
        ])
        
        let deleteAction = UIAction { _ in
            self.deleteBtnTapped()
        }
        
        deleteBtn.addAction(deleteAction, for: .touchUpInside)
    }
    
    private func configForm() {
        formView.config(with: contact)
    }
    
    private func deleteBtnTapped() {
        showDeleteAlert(for: contact) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didDeleteContact(self.contact)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneTapped() {
        guard let updatedContact = getContactInfo(with: contact.id) else {
            showAlert(message: "Failed to update contact.")
            return
        }
        delegate?.didUpdateContact(updatedContact)
        navigationController?.popToRootViewController(animated: true)
    }
}
