struct DateSorter: ContactSorter {
    func sort(_ contacts: [Contact]) -> [Contact] {
        contacts.sorted { $0.editedAt > $1.editedAt }
    }
}
