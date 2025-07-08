import Foundation

struct Contact: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var phone: String
    var email: String?
    
    init(id: UUID = UUID(), name: String, phone: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
    }
}
