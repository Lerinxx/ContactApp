import UIKit
import PhoneNumberKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

final class AddContactViewController: BaseContactViewController {
    weak var delegate: AddContactDelegate?
    
    private let addRandomBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.addRandomTitle, for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .secondarySystemBackground
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.newContactTitle
        configNavigation()
        configRandomBtn()
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
    
    private func configRandomBtn() {
        view.addSubview(addRandomBtn)
        
        NSLayoutConstraint.activate([
            addRandomBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addRandomBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addRandomBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addRandomBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let addAction = UIAction { _ in
            self.addRandomBtnPressed()
        }
        addRandomBtn.addAction(addAction, for: .touchUpInside)
    }
    
    private func addRandomBtnPressed() {
        addRandomBtn.isEnabled = false
        addRandomBtn.setTitle(Constants.loadingTitle, for: .normal)
        
        Task {
            do {
                let contact = try await ContactRemoteService.fetchRandom()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didAddContact(contact)
                    self.dismiss(animated: true)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.addRandomBtn.isEnabled = true
                    self.addRandomBtn.setTitle(Constants.addRandomTitle, for: .normal)
                    self.showAlert(message: Constants.errorAddingMessage)
                }
            }
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        guard let contact = getContactInfo() else {
            showAlert(message: Constants.errorCreatingMessage)
            return
        }
        delegate?.didAddContact(contact)
        dismiss(animated: true)
    }
}
