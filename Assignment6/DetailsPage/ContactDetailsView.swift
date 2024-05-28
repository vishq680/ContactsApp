//
//  ContactDetailsView.swift
//  Assignment6
//
//  Created by Vishaq Jayakumar on 2/29/24.
//
// ContactDetailsView.swift

import UIKit

class ContactDetailsView: UIView {
    
    // Define UI elements for displaying contact details
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        // Customize the UI elements and layout
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
        
        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneLabel)
        
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteButton)
        
        self.backgroundColor = UIColor.white // Or any other color you prefer
        
        initConstraints()
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            phoneLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            deleteButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
                
        ])
    }
    
    func configure(with contact: Contact) {
        // Configure UI elements with contact details
        nameLabel.text = "Name: \(contact.name)"
        emailLabel.text = "Email: \(contact.email)"
        phoneLabel.text = "Phone: \(contact.phone)"
    }
}
