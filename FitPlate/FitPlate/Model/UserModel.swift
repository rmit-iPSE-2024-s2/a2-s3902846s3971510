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
 
 The `User` model handles user data including email and password for sign-up and login purposes. It also provides methods for validating user credentials.
 */

@Model
class User {
    
    /// The email associated with the user's account, used for login and authentication.
    @Attribute var email: String
    
    /// The password associated with the user's account, used for authentication.
    @Attribute var password: String

    /**
     Initialises a new `User` instance with the specified email and password.
     
     - Parameters:
        - email: The user's email address, used for logging in and account identification.
        - password: The user's password, stored securely and used for authentication.
     */
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension User {
    
    /**
     Validates the user's password to ensure it meets security criteria.
     
     The password is considered valid if:
     - It contains at least 8 characters.
     - It contains at least one numeric character.
     - It contains at least one special character from this list`!@#$%^&*(),.?":{}|<>`
     
     - Returns: `true` if the password is valid, otherwise `false`.
     */
    
    
    func isPasswordValid() -> Bool {
        // Check if the password is at least 8 characters long
        guard password.count >= 8 else { return false }
        
        // Check for numeric characters
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        // Check for special characters
        let specialCharacterRegex = "[!@#$%^&*(),.?\":{}|<>]"
        let hasSpecialCharacter = password.range(of: specialCharacterRegex, options: .regularExpression) != nil
        
        return hasNumber && hasSpecialCharacter
    }
    
    /**
     Validates the user's email format.
     
     The email is considered valid if it matches the regular expression for typical email formats.
     
     - Returns: `true` if the email is valid, otherwise `false`.
     */
    
    func isEmailValid() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /**
     Updates the user's credentials by validating and saving a new email and password.
     
     - Parameters:
        - newEmail: The new email to be set for the user.
        - newPassword: The new password to be set for the user.
     - Returns: `true` if the credentials are successfully updated, otherwise `false` if validation fails.
     */
    
    func updateCredentials(newEmail: String, newPassword: String) -> Bool {
        guard isEmailValid(newEmail) && isPasswordValid(newPassword) else {
            return false
        }
        
        email = newEmail
        password = newPassword
        return true
    }
    
    /**
     Validates the format of a given email.
     
     - Parameter email: The email to be validated.
     - Returns: `true` if the email is valid, otherwise `false`.
     */
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /**
     Validates the format of a given password.
     
     The password must contain at least 8 characters, one number and one special character.
     
     - Parameter password: The password to be validated.
     - Returns: `true` if the password is valid, otherwise `false`.
     */
    
    private func isPasswordValid(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let specialCharacterRegex = "[!@#$%^&*(),.?\":{}|<>]"
        let hasSpecialCharacter = password.range(of: specialCharacterRegex, options: .regularExpression) != nil
        return hasNumber && hasSpecialCharacter
    }

    /**
     Checks if the user's account is currently active.
     
     This method can be expanded in the future to include logic such as email verification status or account activation checks.
     
     - Returns: `true` if the account is considered active, otherwise `false`.
     */
    
    func isAccountActive() -> Bool {
        return true
    }
}
