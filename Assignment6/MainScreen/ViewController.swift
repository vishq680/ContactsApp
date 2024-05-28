//
//  ViewController.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    //MARK: list to display the contact names in the TableView...
    var contactNames = [String]()
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts JSON API"
        
        //MARK: setting the delegate and data source...
        mainScreen.tableViewContacts.dataSource = self
        mainScreen.tableViewContacts.delegate = self
        //MARK: removing the separator line...
        mainScreen.tableViewContacts.separatorStyle = .none
        
        //get all contact names when the main screen loads...
        getAllContacts()
        NotificationCenter.default.addObserver(self, selector: #selector(contactsUpdated), name: NSNotification.Name("ContactsUpdated"), object: nil)
        
        
        
        //MARK: add action to Add Contact button...
        mainScreen.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }
    
    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func contactsUpdated() {
        // Refresh data in the ViewController
        getAllContacts()
    }
    
    @objc func onButtonAddTapped() {
        // Do the validations...
        guard let name = mainScreen.textFieldAddName.text,
              let email = mainScreen.textFieldAddEmail.text,
              let phoneText = mainScreen.textFieldAddPhone.text else {
            // Handle the case when any of the required fields are empty
            showAlert(message: "Please fill in all the required fields.")
            return
        }
        
        // Validate email format
        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            return
        }
        
        // Validate phone number
        guard let phone = Int(phoneText), isValidPhoneNumber(phoneText) else {
            showAlert(message: "Please enter a valid 10-digit phone number.")
            return
        }
        
        // The email is valid, and phone has 10 digits and only numbers...
        
        let contact = Contact(name: name, email: email, phone: phone)
        
        // Call add a new contact API endpoint...
        addANewContact(contact: contact)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Implement your email validation logic here
        // You can use regular expressions or other methods to validate the email format
        // For a simple check, you can use the following:
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Implement your phone number validation logic here
        // For a simple check, you can ensure the phone number has exactly 10 digits and only contains numbers
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    
    func clearAddViewFields(){
        mainScreen.textFieldAddName.text = ""
        mainScreen.textFieldAddEmail.text = ""
        mainScreen.textFieldAddPhone.text = ""
    }
    
    func showDetailsInAlert(data: String){
        let parts = data.components(separatedBy: ",")
        print(parts)
        
        //MARK: trim the whitespaces from the strings, and show alert...
        let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let email = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
        if let phone = Int(parts[2].trimmingCharacters(in: .whitespacesAndNewlines)){
            //MARK: show alert...
            let message = """
                name: \(name)
                email: \(email)
                phone: \(phone)
                """
            let alert = UIAlertController(title: "Selected Contact", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        
    }
    
    //MARK: add a new contact call: add endpoint...
    func addANewContact(contact: Contact){
        if let url = URL(string: APIConfigs.baseURL+"add"){
            
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
                            self.getAllContacts()
                            self.clearAddViewFields()
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
    
    //MARK: get all contacts call: getall endpoint...
    func getAllContacts(){
        if let url = URL(string: APIConfigs.baseURL + "getall"){
            AF.request(url, method: .get).responseString(completionHandler: { response in
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
                            let names = data.components(separatedBy: "\n")
                            self.contactNames = names
                            self.contactNames.removeLast()
                            self.mainScreen.tableViewContacts.reloadData()
                            print(self.contactNames)
                            NotificationCenter.default.post(name: NSNotification.Name("ContactsUpdated"), object: nil)
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
        }
    }
    
    //MARK: get details of a contact...
    func getContactDetails(name: String){
        if let url = URL(string: APIConfigs.baseURL+"details"){
            AF.request(url, method:.get,
                       parameters: ["name":name],
                       encoding: URLEncoding.queryString)
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
                            if let contactDetailsVC = self.createContactDetailsViewController(from: data) {
                                // Push the ContactDetailsViewController onto the navigation stack
                                self.navigationController?.pushViewController(contactDetailsVC, animated: true)
                            }
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
        }
    }
    
    func createContactDetailsViewController(from details: String) -> ContactDetailsViewController? {
        let contactDetailsVC = ContactDetailsViewController()
        
        // Parse data and set contactDetailsVC.contact with the details
        let detailsArray = details.components(separatedBy: ",")
        guard detailsArray.count >= 3 else {
            print("Invalid details format")
            return nil
        }
        
        let name = detailsArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let email = detailsArray[1].trimmingCharacters(in: .whitespacesAndNewlines)
        if let phone = Int(detailsArray[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
            contactDetailsVC.contact = Contact(name: name, email: email, phone: phone)
            return contactDetailsVC
        } else {
            print("Invalid phone format")
            return nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "names", for: indexPath) as! ContactsTableViewCell
        cell.labelName.text = contactNames[indexPath.row]
        
        // Add an action to the edit button
        cell.editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row  // Set the tag to identify which row's edit button is tapped
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getContactDetails(name: self.contactNames[indexPath.row])
    }
    @objc func editButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        // Handle the edit action for the corresponding contact at rowIndex
        // You can navigate to the edit page or perform any other action as needed
        print("Edit button tapped for contact at row \(rowIndex)")
    }
}



