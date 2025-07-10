import UIKit
import PhoneNumberKit

final class ContactCell: UITableViewCell {
    static var identifier: String { "\(Self.self)" }
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        phoneLabel.text = nil
    }
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        
        let phoneUtil = PhoneNumberUtility()
        if let parsedNumber = try? phoneUtil.parse(contact.phone) {
            phoneLabel.text = phoneUtil.format(parsedNumber, toType: .international)
        } else {
            phoneLabel.text = contact.phone
        }
        
        if let filename = contact.imageFilename,
           let image = ImageStorage.shared.loadImage(filename: filename) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = Constants.defaultAvatar
        }
    }
    
    private func configUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 12),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            phoneLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            phoneLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
            phoneLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
