import UIKit

final class ContactDetailViewController: UIViewController {
    weak var delegate: EditContactDelegate?
    private let contact: Contact
    
    private let formView: ContactFormView = {
        let view = ContactFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        configUI()
        configNavigation()
        configForm()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(formView)
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            formView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        formView.setEditable(false)
    }
    
    private func configForm() {
        formView.config(with: contact)
    }
    
    private func configNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
    }
    
    @objc private func editTapped() {
        let controller = EditContactViewController(contact: contact)
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
}
