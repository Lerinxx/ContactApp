import UIKit

class ViewController: UIViewController {
    private let contactManager = ContactManager()
    
    private lazy var contactsTable: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupNavigationBar()
        title = "Contacts"
        print("lol")
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(contactsTable)
        
        NSLayoutConstraint.activate([
            contactsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            contactsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contactsTable.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
    }
    
    @objc private func addTapped() {
        let addVC = AddContactViewController()
        addVC.delegate = self
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactManager.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        let contact = contactManager.contacts[indexPath.row]
        cell.configure(with: contact)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = contactManager.contacts[indexPath.row]
            contactManager.deleteContact(contact)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: AddContactDelegate {
    func didAddContact(_ contact: Contact) {
        contactManager.addContact(contact)
        contactsTable.reloadData()
    }
}

