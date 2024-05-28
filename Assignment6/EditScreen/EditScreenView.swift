//
//  EditScreenView.swift
//  Assignment6
//
//  Created by Vishaq Jayakumar on 2/29/24.
//

import UIKit

class EditContactView: UIView {
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var phoneTextField: UITextField!
    var saveButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Implement your UI elements and layout here
        // Include labels, text fields, and a save button

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)

        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)

        phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneLabel)

        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameTextField)

        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)

        phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneTextField)

        saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(saveButton)

        // Add constraints for labels, text fields, and button
        // ...

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            phoneLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            phoneTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),



            
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16),
            saveButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),


        ])
    }
}
