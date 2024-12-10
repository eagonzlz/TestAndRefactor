//
//  UserValidator.swift
//  UserManager
//
//  Created by Emanuel Gonzalez on 12/9/24.
//

import Foundation

class UserValidator {
    func isValid(details: User) -> Bool {
        if details.fullName.isEmpty || details.email.isEmpty || details.password.isEmpty {
            print("All fields must be filled")
            return false
        }
        if !details.email.contains("@") {
            print("Invalid email address")
            return false
        }
        if details.password.count < 6 {
            print("Password must be at least 6 characters")
            return false
        }
        if details.age < 18 {
            print("User must be at least 18 years old")
            return false
        } else {
            return true
        }
    }
    
    func authenticateUser(email: String, password: String, database: Database) -> Bool {
        guard let user = database.getUserByEmail(email: email) else {
            return false // User not found
        }
        return user.password == password // Password check
    }
}
