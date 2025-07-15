import Foundation

struct Contact: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var phone: String
    var imageFilename: String?
    let editedAt: Date
    
    init(id: UUID = UUID(), name: String, phone: String, imageFilename: String? = nil, editedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.phone = phone
        self.imageFilename = imageFilename
        self.editedAt = editedAt
    }
}
