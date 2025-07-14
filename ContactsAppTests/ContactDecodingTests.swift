import XCTest
@testable import ContactsApp

final class ContactDecodingTests: XCTestCase {
    
    func testContactDecodingFromJSON() throws {
        let jsonString = """
            {
                "id": "E91F7FA6-DC2F-4E56-AF9C-3DAAD4A004F2",
                "name": "Bob Kelso",
                "phone": "+1 555-1234",
                "imageFilename": "bob-kelso.jpg",
                "editedAt": "2025-07-10T14:30:00Z"
            }
            """
        
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let contact = try decoder.decode(Contact.self, from: jsonData)
        
        XCTAssertEqual(contact.id, UUID(uuidString: "E91F7FA6-DC2F-4E56-AF9C-3DAAD4A004F2"))
        XCTAssertEqual(contact.name, "Bob Kelso")
        XCTAssertEqual(contact.phone, "+1 555-1234")
        XCTAssertEqual(contact.imageFilename, "bob-kelso.jpg")
        
        let expectedDate = ISO8601DateFormatter().date(from: "2025-07-10T14:30:00Z")
        XCTAssertEqual(contact.editedAt, expectedDate)
    }
}
