//
//  ContactDetailsViewController.swift
//  Assignment6
//
//  Created by Vishaq Jayakumar on 2/29/24.
//

import UIKit
import Alamofire

class ContactDetailsViewController: UIViewController {
    var contactDetailsView = ContactDetailsView()
    
    var contact: Contact? // Assuming you have a Contact model
    
    override func loadView() {
        view = contactDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up your UI elements with contact details
        if let contact = contact {
            contactDetailsView.nameLabel.text = "Name: \(contact.name)"
            contactDetailsView.emailLabel.text = "Email: \(contact.email)"
            contactDetailsView.phoneLabel.text = "Phone: \(contact.phone)"
        }
        contactDetailsView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
    }
    @objc func deleteButtonTapped() {
        // Handle delete action here
        confirmDelete()
    }
    
    func confirmDelete() {
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteContact()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteContact() {
        if let contact = contact, let url = URL(string: APIConfigs.baseURL + "delete") {
            AF.request(url, method: .get, parameters: ["name": contact.name],
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
        NotificationCenter.default.post(name: NSNotification.Name("ContactDeleted"), object: nil)

        // Optionally, you can navigate back to the previous screen or perform any other actions
        navigationController?.popViewController(animated: true)
    }

}
