import UIKit

final class Constants {
    //api
    static let randomUserApi = "https://randomuser.me/api/"
    //images
    static let defaultAvatar = UIImage(systemName: "person.circle.fill")?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    //labels btns texts
    static let photoBtnTitle = "Add Photo"
    static let namePlaceholder = "Name"
    static let phonePlaceholder = "Phone number"
    static let addRandomTitle = "Add Random Contact 🍀"
    static let newContactTitle = "New contact"
    static let editContactTitle = "Edit contact"
    static let contactsTitle = "Contacts"
    static let loadingTitle = "Loading..."
    // alert texts
    static let errorTitle = "Error!"
    static let okTitle = "OK"
    static let deleteContactTitle = "Delete Contact"
    static let deleteMessage = "Are you sure you want to delete this contact?"
    static let cancelTitle = "Cancel"
    static let deleteTitle = "Delete"
    static let sortTitle = "Sort Contacts ⚙️"
    static let sortMessage = "Select sorting option"
    static let byNameTitle = "By Name"
    static let byDateTitle = "By Date Edited"
    static let errorAddingMessage = "Couldn't add contact. Try again!"
    static let errorCreatingMessage = "Failed to create contact."
    static let errorUpdateMessage = "Failed to update contact."
}
