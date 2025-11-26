//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @_exported import Spezi
@_exported import Vapor

public struct SpeziApplicationNamespace {
    private enum SpeziStorageKey: StorageKey {
        typealias Value = Spezi
    }
    
    private let application: Application
    
    var spezi: Spezi {
        guard let spezi = application.storage[SpeziStorageKey.self] else {
            preconditionFailure("Spezi not configured. Ensure Spezi is added to Application storage before use.")
        }
        return spezi
    }

    init(application: Application) {
        self.application = application
    }
    
    @MainActor
    public func configure<S: Standard>(standard: S, @ModuleBuilder _ modules: () -> ModuleCollection) {
        application.storage[SpeziStorageKey.self] = Spezi(from: Configuration(standard: standard, modules))
    }
    
    public subscript<M: Module>(_: M.Type) -> M {
        guard let module: M = self[M?.self] else {
            preconditionFailure("Module \(M.self) not configured in Spezi.")
        }
        return module
    }
    
    public subscript<M: Module>(_: M?.Type) -> M? {
        spezi.module()
    }
}

extension Application {
    public var spezi: SpeziApplicationNamespace {
        SpeziApplicationNamespace(application: self)
    }
}
