//
//  Contact.swift
//  Assignment6
//
//  Created by Vishaq Jayakumar on 2/29/24.
//

import Foundation
//MARK: struct for a contact...
struct Contact{
    var name:String
    var email:String
    var phone: Int
    
    init(name: String, email: String, phone: Int) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
