import UIKit

class ViewController: UIViewController {
    private let contactManager = ContactManager()
    private var currentSorter: ContactSorter = NameSorter()
    
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
        configNavigationBar()
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
    
    private func configNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
    }
    
    private func applySorting() {
        contactManager.contacts = currentSorter.sort(contactManager.contacts)
        contactsTable.reloadData()
    }
    
    @objc private func addTapped() {
        let controller = AddContactViewController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true)
    }
    
    @objc private func sortTapped() {
        presentSortOptions {
            self.currentSorter = NameSorter()
            self.applySorting()
        } onDateSelected: {
            self.currentSorter = DateSorter()
            self.applySorting()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactManager.contacts[indexPath.row]
        let detailVC = ContactDetailViewController(contact: selectedContact)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: AddContactDelegate {
    func didAddContact(_ contact: Contact) {
        contactManager.addContact(contact)
        let newIndex = contactManager.contacts.count - 1
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        contactsTable.insertRows(at: [newIndexPath], with: .automatic)
    }
}

extension ViewController: EditContactDelegate {
    func didUpdateContact(_ contact: Contact) {
        contactManager.updateContact(contact)
        contactsTable.reloadData()
    }
    
    func didDeleteContact(_ contact: Contact) {
        if let index = contactManager.contacts.firstIndex(where: { $0.id == contact.id }) {
            contactManager.deleteContact(contact)
            contactsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

