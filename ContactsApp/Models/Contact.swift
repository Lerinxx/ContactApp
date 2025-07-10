import Foundation

struct Contact: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var phone: String
    var imageFilename: String?
    
    init(id: UUID = UUID(), name: String, phone: String, imageFilename: String? = nil) {
        self.id = id
        self.name = name
        self.phone = phone
        self.imageFilename = imageFilename
    }
}
