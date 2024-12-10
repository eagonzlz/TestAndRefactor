//
//  UserManagerTests.swift
//  UserManagerTests
//
//  Created by Emanuel Gonzalez on 12/9/24.
//

import XCTest
@testable import UserManager

class MockDatabase: Database {
    private var mockUsers: [User] = []
    
    override func save(user: User) {
        mockUsers.append(user)
    }
    
    override func getUserByEmail(email: String) -> User? {
        return mockUsers.first { $0.email == email }
    }
}

class MockEmailService: EmailService {
    var emailSentTo: String?
    func sendWelcomeEmail(email: String) { //can't override static method
        emailSentTo = email
    }
}

class MockUserValidator: UserValidator {
    override func authenticateUser(email: String, password: String, database: Database) -> Bool {
        guard let user = database.getUserByEmail(email: email) else {
            return false // User not found
        }
        return user.password == password // Password check
        
    }
}

class UserManagerTests: XCTestCase {
    var userManager: UserManager!
    var mockDatabase: MockDatabase!
    var mockEmailService: MockEmailService!
    var mockUserValidator: MockUserValidator!
    
    override func setUp() {
        super.setUp()
        mockDatabase = MockDatabase()
        mockUserValidator = MockUserValidator()
        mockEmailService = MockEmailService()
        mockUserValidator = MockUserValidator()
        userManager = UserManager(database: mockDatabase, emailService: mockEmailService)
    }
    
    override func tearDown() {
        userManager = nil
        mockDatabase = nil
        mockEmailService = nil
        mockUserValidator = nil
        super.tearDown()
    }
    
    func testSuccessfulUserRegistration() {
        let details = User(
            fullName: "John",
            email: "john.doe@example.com",
            password: "password123",
            age: 25
        )
        userManager.registerUser(details: details)
        
        let savedUser = mockDatabase.getUserByEmail(email: "john.doe@example.com")
        
        XCTAssertEqual(savedUser?.email, details.email)
        XCTAssertEqual(mockEmailService.emailSentTo, details.email)
    }

    
    func testRegistrationFailsWithInvalidData() {
        let details = User(
            fullName: "",
            email: "invalidemail",
            password: "123",
            age: 15
        )
        
        XCTAssertFalse(mockUserValidator.isValid(details: details))
    }
    
    func testAuthenticationWithValidCredentials() {
        let user = User(
            fullName: "Jane",
            email: "jane.doe@example.com",
            password: "securepass",
            age: 30
        )
        mockDatabase.save(user: user)
        
        let isAuthenticated = mockUserValidator.authenticateUser(email: "jane.doe@example.com", password: "securepass", database: mockDatabase)
        XCTAssertTrue(isAuthenticated)
    }
    
    func testAuthenticationFailsWithInvalidCredentials() {
        let user = User(
            fullName: "Jane",
            email: "jane.doe@example.com",
            password: "securepass",
            age: 30
        )
        mockDatabase.save(user: user)
        
        let isAuthenticated = mockUserValidator.authenticateUser(email: "jane.doe@example.com", password: "wrongpass", database: mockDatabase)
        XCTAssertFalse(isAuthenticated)
    }
    
    func testAuthenticationFailsForNonExistentUser() {
        let isAuthenticated = mockUserValidator.authenticateUser(email: "jane.doe@example.com", password: "wrongpass", database: mockDatabase)
        XCTAssertFalse(isAuthenticated)
    }
}

