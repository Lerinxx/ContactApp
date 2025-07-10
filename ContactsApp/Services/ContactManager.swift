import Foundation

final class ContactManager {
    private(set) var contacts: [Contact] = []
    
    init() {
        loadContacts()
    }
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        persist()
    }
    
    func updateContact(_ contact: Contact) {
        guard let index = contacts.firstIndex(where: { $0.id == contact.id }) else { return }
        contacts[index] = contact
        persist()
    }
    
    func deleteContact(_ contact: Contact) {
        contacts.removeAll { $0.id == contact.id }
        
        if let filename = contact.imageFilename {
            try? ImageStorage.shared.deleteImage(filename: filename)
        }
        
        persist()
    }
    
    func loadContacts() {
        contacts = ContactStorage.shared.load()
    }
    
    private func persist() {
        ContactStorage.shared.save(contacts)
    }
}
