//
//  UserModel.swift
//  FitPlate
//
//  Created by Monessha Vetrivelan on 10/10/2024.
//

import Foundation
import SwiftData


@Model
class User {
    @Attribute var email: String
    @Attribute var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}


