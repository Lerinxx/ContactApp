import UIKit
import PhoneNumberKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

final class AddContactViewController: UIViewController {
    weak var delegate: AddContactDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        imageView.image = Constants.defaultAvatar
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let photoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Photo", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .secondarySystemBackground
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.placeholder = "Name"
        nameField.borderStyle = .roundedRect
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()
    
    private let phoneField: PhoneNumberTextField = {
        let phoneField = PhoneNumberTextField()
        phoneField.placeholder = "Phone number"
        phoneField.withPrefix = true
        phoneField.borderStyle = .roundedRect
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        return phoneField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New contact"
        configUI()
        configNavigation()
        configValidation()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(photoBtn)
        containerView.addSubview(nameField)
        containerView.addSubview(phoneField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            photoBtn.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            photoBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            photoBtn.widthAnchor.constraint(equalToConstant: 130),
            photoBtn.heightAnchor.constraint(equalToConstant: 35),
            
            nameField.topAnchor.constraint(equalTo: photoBtn.bottomAnchor, constant: 20),
            nameField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            nameField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12),
            phoneField.leftAnchor.constraint(equalTo: nameField.leftAnchor),
            phoneField.rightAnchor.constraint(equalTo: nameField.rightAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let selectAction = UIAction { _ in
            self.photoBtnTapped()
        }
        photoBtn.addAction(selectAction, for: .touchUpInside)
    }
    
    private func photoBtnTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configValidation() {
        nameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        let nameValid = !(nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let phoneValid = !(phoneField.text?.isEmpty ?? true)
        
        navigationItem.rightBarButtonItem?.isEnabled = nameValid && phoneValid
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        guard let name = nameField.text, let rawPhone = phoneField.text else { return }
        
        let phoneUtil = PhoneNumberUtility()
        var formattedPhone: String
        
        do {
            let parsedNumber = try phoneUtil.parse(rawPhone)
            formattedPhone = phoneUtil.format(parsedNumber, toType: .international)
        } catch {
            showAlert(message: "Invalid phone number format.")
            return
        }
        
        var imageFilename: String? = nil
        if let image = imageView.image,
           image != Constants.defaultAvatar {
            do {
                imageFilename = try ImageStorage.shared.saveImage(image)
            } catch {
                showAlert(message: "Couldn't save photo. Please try again.")
            }
        }
        
        let contact = Contact(name: name, phone: formattedPhone, imageFilename: imageFilename)
        delegate?.didAddContact(contact)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
    }
}
