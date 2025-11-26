//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
@testable import SpeziVapor
import Testing
import Vapor


class DataModule: Module {
    struct UserData: Content {
        let id: Int
        let name: String
        let email: String
    }
    
    private let userData: [UserData]
    
    init(userData: [UserData] = []) {
        self.userData = userData
    }
    
    /// Returns all stored user data.
    func getAllUsers() -> [UserData] {
        userData
    }
    
    /// Returns a user by ID, if found.
    func getUser(byId id: Int) -> UserData? {
        userData.first { $0.id == id }
    }
}

@MainActor
@Suite("Data Module Tests", .serialized)
struct DataModuleTests {
    let testUsers = [
        DataModule.UserData(id: 1, name: "Alice", email: "alice@example.com"),
        DataModule.UserData(id: 2, name: "Bob", email: "bob@example.com")
    ]

    @Test
    func dataModuleReturnsUsers() async throws {
        try await withSpeziApp(standard: TestStandard(), modules: { DataModule(userData: testUsers) }) { app in
            try await app.testing().test(.GET, "users", afterResponse: { @Sendable res in
                #expect(res.status == .ok)
                let users = try res.content.decode([DataModule.UserData].self)
                #expect(users.count == 2)
                #expect(users.contains { $0.id == 1 })
                #expect(users.contains { $0.id == 2 })
            })
        }
    }
    
    @Test
    func dataModuleReturnsUser() async throws {
        try await withSpeziApp(standard: TestStandard(), modules: { DataModule(userData: testUsers) }) { app in
            try await app.testing().test(.GET, "users/1", afterResponse: { @Sendable res in
                #expect(res.status == .ok)
                let user = try res.content.decode(DataModule.UserData.self)
                #expect(user.id == 1)
                #expect(user.name == "Alice")
                #expect(user.email == "alice@example.com")
            })
        }
    }
    
    @Test
    func dataModuleReturnsUserNotFound() async throws {
        try await withSpeziApp(standard: TestStandard(), modules: { DataModule(userData: testUsers) }) { app in
            try await app.testing().test(.GET, "users/999", afterResponse: { @Sendable res in
                #expect(res.status == .notFound)
            })
        }
    }
}
