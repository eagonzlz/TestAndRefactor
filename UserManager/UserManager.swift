//
//  UserManager.swift
//  UserManager
//
//  Created by Emannuel Gonzalez on 12/9/24.
//

import Foundation

class UserManager {
    private let userValidator = UserValidator()
    private let emailService: EmailService
    private let database: Database

    init(database: Database, emailService: EmailService) {
        self.database = database
        self.emailService = emailService
    }
    
    func registerUser(details: User) {
        let user = User(
            fullName: details.fullName,
            email: details.email,
            password: details.password,
            age: details.age
        )
        if userValidator.isValid(details: details) {
            database.save(user: user)
            EmailService.sendWelcomeEmail(email: details.email)
            print("User registered successfully!")
        } else {
            print("User registration failed!")
        }
    }
}
