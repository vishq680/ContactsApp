//
//  EditScreenViewController.swift
//  Assignment6
//
//  Created by Vishaq Jayakumar on 2/29/24.
//

import UIKit
import Alamofire

class EditContactViewController: UIViewController {
    var editContactView = EditContactView()
    var contact: Contact?
    var originalContact: Contact?
    
    
    override func loadView() {
        view = editContactView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Contact"
        
        // Load the edit screen with contact details
        if let contact = contact {
            editContactView.nameTextField.text = contact.name
            editContactView.emailTextField.text = contact.email
            editContactView.phoneTextField.text = "\(contact.phone)"
        }
        
        // Add action to save button
        editContactView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        // Update the local contact object with edited information
        if let updatedName = editContactView.nameTextField.text,
           let updatedEmail = editContactView.emailTextField.text,
           let updatedPhoneText = editContactView.phoneTextField.text,
           let updatedPhone = Int(updatedPhoneText) {
            
            // Update the contact object
            let originalContact = Contact(name: contact?.name ?? "",
                                          email: contact?.email ?? "",
                                          phone: contact?.phone ?? 0)
            
            // Update the contact object
            contact?.name = updatedName
            contact?.email = updatedEmail
            contact?.phone = updatedPhone
            
            // Call delete API to delete the old contact
            deleteContact(originalContact)
        }
    }
    
    func deleteContact(_ originalContact: Contact) {
        if let url = URL(string: APIConfigs.baseURL + "delete") {
            AF.request(url, method: .get, parameters: ["name": originalContact.name],
                       encoding: URLEncoding.queryString)
            .responseString(completionHandler: { response in
                //MARK: retrieving the status code...
                let status = response.response?.statusCode
                
                switch response.result {
                case .success(let data):
                    //MARK: there was no network error...
                    
                    //MARK: status code is Optional, so unwrapping it...
                    if let uwStatusCode = status {
                        switch uwStatusCode {
                        case 200...299:
                            //MARK: the request was valid 200-level...
                            print(data)
                            self.addUpdatedContact() // Move this inside success block
                            NotificationCenter.default.post(name: NSNotification.Name("ContactDeleted"), object: nil)
                            // Optionally, you can navigate back to the previous screen or perform any other actions
                            self.navigationController?.popViewController(animated: true)
                            break
                            
                        case 400...499:
                            //MARK: the request was not valid 400-level...
                            print(data)
                            break
                            
                        default:
                            //MARK: probably a 500-level error...
                            print(data)
                            break
                        }
                    }
                    break
                    
                case .failure(let error):
                    //MARK: there was a network error...
                    print(error)
                    break
                }
            })
        } else {
            //alert that the URL is invalid...
        }
    }
    
    
    func addUpdatedContact() {
        if let contact = contact, let url = URL(string: APIConfigs.baseURL+"add"){
            
            AF.request(url, method:.post, parameters:
                        [
                            "name": contact.name,
                            "email": contact.email,
                            "phone": contact.phone
                        ])
            .responseString(completionHandler: { response in
                //MARK: retrieving the status code...
                let status = response.response?.statusCode
                
                switch response.result{
                case .success(let data):
                    //MARK: there was no network error...
                    
                    //MARK: status code is Optional, so unwrapping it...
                    if let uwStatusCode = status{
                        switch uwStatusCode{
                        case 200...299:
                            //MARK: the request was valid 200-level...
                            print(data)
                            break
                            
                        case 400...499:
                            //MARK: the request was not valid 400-level...
                            print(data)
                            break
                            
                        default:
                            //MARK: probably a 500-level error...
                            print(data)
                            break
                            
                        }
                    }
                    break
                    
                case .failure(let error):
                    //MARK: there was a network error...
                    print(error)
                    break
                }
            })
        }else{
            //alert that the URL is invalid...
        }
    }
}
