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

extension User {
    func isPasswordValid() -> Bool {
        // Check if the password is at least 8 characters
        guard password.count >= 8 else { return false }
        
        // Check for numeric characters
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        // Check for special characters
        let specialCharacterRegex = "[!@#$%^&*(),.?\":{}|<>]"
        let hasSpecialCharacter = password.range(of: specialCharacterRegex, options: .regularExpression) != nil
        
        return hasNumber && hasSpecialCharacter
    }
    
    func isEmailValid() -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
    
    func updateCredentials(newEmail: String, newPassword: String) -> Bool {
            guard isEmailValid(newEmail) && isPasswordValid(newPassword) else {
                return false
            }
            
            email = newEmail
            password = newPassword
            return true
        }
        
    private func isEmailValid(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
        
    private func isPasswordValid(_ password: String) -> Bool {
            guard password.count >= 8 else { return false }
            let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
            let specialCharacterRegex = "[!@#$%^&*(),.?\":{}|<>]"
            let hasSpecialCharacter = password.range(of: specialCharacterRegex, options: .regularExpression) != nil
            return hasNumber && hasSpecialCharacter
        }
    func isAccountActive() -> Bool {
            // Example criteria: email is verified (assuming another attribute 'isEmailVerified')
            // This example assumes there's a property `isEmailVerified` which is a Bool
            // return isEmailVerified
            
            // As this is a placeholder, let's assume the account is always active for simplicity
            return true
        }
}
