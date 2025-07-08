import Foundation

final class ContactStorage {
    static let shared = ContactStorage()
    
    private let key = "saved"
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func load() -> [Contact] {
        guard let data = defaults.data(forKey: key),
              let contacts = try? JSONDecoder().decode([Contact].self, from: data) else {
            return []
        }
        return contacts
    }
    
    func save(_ contacts: [Contact]) {
        guard let data = try? JSONEncoder().encode(contacts) else { return }
        defaults.set(data, forKey: key)
    }
}
