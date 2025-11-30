//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import Vapor


extension Request {
    /// A namespace for accessing Spezi modules within a Vapor request handler.
    ///
    /// Use this struct to access configured modules in your route handlers:
    ///
    /// ```swift
    /// app.get("users") { req async throws -> [User] in
    ///     let userModule = req.spezi[UserModule.self]
    ///     return userModule.getAllUsers()
    /// }
    /// ```
    public struct Spezi {
        private let request: Request
        
        init(request: Request) {
            self.request = request
        }
        
        /// Accesses a configured module by its type.
        ///
        /// - Parameter type: The type of the module to retrieve.
        /// - Returns: The configured module instance.
        /// - Precondition: The module must be configured, otherwise a `preconditionFailure` is triggered.
        public subscript<M: Module & Sendable>(_ type: M.Type) -> M {
            request.application.spezi[type]
        }
        
        /// Optionally accesses a configured module by its type.
        ///
        /// - Parameter type: The optional type of the module to retrieve.
        /// - Returns: The configured module instance, or `nil` if not configured.
        public subscript<M: Module & Sendable>(_ type: M?.Type) -> M? {
            request.application.spezi[type]
        }
    }
    
    /// Access Spezi modules in route handlers.
    public var spezi: Spezi {
        Spezi(request: self)
    }
}
