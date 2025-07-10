import UIKit
import PhoneNumberKit

class BaseContactViewController: UIViewController {
    let phoneUtil = PhoneNumberUtility()
    
    private(set) var formView: ContactFormView = {
        let view = ContactFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configValidation()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(formView)
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            formView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            formView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            formView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let selectAction = UIAction { _ in
            self.openPhotoLibrary()
        }
        formView.photoBtn.addAction(selectAction, for: .touchUpInside)
    }
    
    private func configValidation() {
        formView.nameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        formView.phoneField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        let nameValid = !(formView.nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let phoneValid = !(formView.phoneField.text?.isEmpty ?? true)
        navigationItem.rightBarButtonItem?.isEnabled = nameValid && phoneValid
    }
    
    func getContactInfo(with id: UUID? = nil) -> Contact? {
        guard let name = formView.nameField.text,
              let rawPhone = formView.phoneField.text else { return nil }
        
        var formattedPhone = rawPhone
        if let parsed = try? phoneUtil.parse(rawPhone) {
            formattedPhone = phoneUtil.format(parsed, toType: .international)
        }
        
        var imageFilename: String?
        if let image = formView.imageView.image, image != Constants.defaultAvatar {
            imageFilename = try? ImageStorage.shared.saveImage(image)
        }
        
        return Contact(id: id ?? UUID(), name: name, phone: formattedPhone, imageFilename: imageFilename)
    }
    
    private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            formView.imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            formView.imageView.image = originalImage
        }
    }
}

