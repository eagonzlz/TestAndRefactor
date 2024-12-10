//
//  database.swift
//  UserManager
//
//  Created by Emanuel Gonzalez on 12/9/24.
//

import Foundation

class  Database {
    private var users: [User] = []

    func save(user: User) {
        users.append(user)
    }

    func getUserByEmail(email: String) -> User? {
        return users.first { $0.email == email }
    }
}
