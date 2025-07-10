import UIKit
import PhoneNumberKit

final class ContactFormView: UIView {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 100
        iv.clipsToBounds = true
        iv.image = Constants.defaultAvatar
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let photoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Photo", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .secondarySystemBackground
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneField: PhoneNumberTextField = {
        let tf = PhoneNumberTextField()
        tf.placeholder = "Phone number"
        tf.withPrefix = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with contact: Contact) {
        nameField.text = contact.name
        phoneField.text = contact.phone
        if let filename = contact.imageFilename,
           let image = ImageStorage.shared.loadImage(filename: filename) {
            imageView.image = image
        } else {
            imageView.image = Constants.defaultAvatar
        }
    }
    
    func setEditable(_ editable: Bool) {
        nameField.isUserInteractionEnabled = editable
        phoneField.isUserInteractionEnabled = editable
        photoBtn.isHidden = !editable
    }
    
    private func configUI() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(photoBtn)
        containerView.addSubview(nameField)
        containerView.addSubview(phoneField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
    }
}

