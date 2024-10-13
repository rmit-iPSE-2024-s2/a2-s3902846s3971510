//
//  UserModel.swift
//  FitPlate
//
//  Created by Monessha Vetrivelan on 10/10/2024.
//

import Foundation
import SwiftData


/**
 A model class representing a user in the FitPlate app.
 */

@Model
class User {
    
    /// User  data that is needed to sign up and login by validation

    /// This is the email associated with the account
    @Attribute var email: String
    
    /// This is the stored password for the user's account.
    @Attribute var password: String

    /**
     Initializes a new `User` instance with the specified email and password
     */
    
    ///  User Login information.
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
