//
//  ContentView.swift
//  UserManager
//
//  Created by Emanuel Gonzalez on 12/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: String = ""
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    @State private var message: String = ""

    private let database: Database
    private let userManager: UserManager
    private let emailService: EmailService

    init() {
        self.database = Database()
        self.emailService = EmailService()
        self.userManager = UserManager(database: database, emailService: emailService)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Register User")) {
                    TextField("Full Name", text: $fullName)
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)

                    Button(action: registerUser) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                Section(header: Text("Authenticate User")) {
                    TextField("Email", text: $loginEmail)
                    SecureField("Password", text: $loginPassword)

                    Button(action: authenticateUser) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                Section(header: Text("Message")) {
                    Text(message)
                        .foregroundColor(.green)
                        .lineLimit(nil)
                }
            }
            .navigationTitle("User Management")
        }
    }


    private func registerUser() {
        guard let userAge = Int(age) else {
            message = "Age must be a valid number."
            return
        }

        let details = User(
            fullName: "",
            email: email,
            password: password,
            age: userAge
        )
                
        userManager.registerUser(details: details)
        message = "User registered successfully!"
    }

    private func authenticateUser() {
        let userValidator = UserValidator()
        let isAuthenticated = userValidator.authenticateUser(email: loginEmail, password: loginPassword, database: database)
        message = isAuthenticated ? "Login successful!" : "Invalid credentials."
    }
}

#Preview {
    ContentView()
}
