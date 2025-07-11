struct DateSorter: ContactSorter {
    func sort(_ contacts: [Contact]) -> [Contact] {
        contacts.sorted { $0.createdAt < $1.createdAt }
    }
}
