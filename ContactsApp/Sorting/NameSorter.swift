struct NameSorter: ContactSorter {
    func sort(_ contacts: [Contact]) -> [Contact] {
        contacts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
