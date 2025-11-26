//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_exported import Spezi
@_exported import Vapor

public struct SpeziRequestNamespace {
    private let request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    public subscript<M: Module>(_ type: M.Type) -> M {
        request.application.spezi[type]
    }
    
    public subscript<M: Module>(_ type: M?.Type) -> M? {
        request.application.spezi[type]
    }
}

extension Request {
    public var spezi: SpeziRequestNamespace {
        SpeziRequestNamespace(request: self)
    }
}
