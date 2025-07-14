import XCTest
@testable import ContactsApp

final class ContactSortingTests: XCTestCase {
    func testSortByName() {
        let contacts = [
            Contact(name: "Perry", phone: "123"),
            Contact(name: "Carla", phone: "456"),
            Contact(name: "Bob", phone: "789")
        ]
        let sorted = NameSorter().sort(contacts)
        let sortedNames = sorted.map { $0.name }
        XCTAssertEqual(sortedNames, ["Bob", "Carla", "Perry"])
    }
    
    func testSortByDateEdited() {
        let contacts = [
            Contact(name: "A", phone: "1", editedAt: Date(timeIntervalSince1970: 1000)),
            Contact(name: "B", phone: "2", editedAt: Date(timeIntervalSince1970: 3000)),
            Contact(name: "C", phone: "3", editedAt: Date(timeIntervalSince1970: 2000))
        ]
        let sorted = DateSorter().sort(contacts)
        let sortedNames = sorted.map { $0.name }
        XCTAssertEqual(sortedNames, ["B", "C", "A"])
    }
}
