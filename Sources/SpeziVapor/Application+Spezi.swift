//
// This source file is part of the TemplatePackage open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) import Spezi
import Vapor

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
    
    @MainActor
    public func configure<S: Standard>(standard: S, modules: [any Module]) {
        configure(standard: standard, {
            for module in modules {
                module
            }
        })
    }
    
    public subscript<M: Module>(_ type: M.Type) -> M {
        guard let module: M = spezi.module() else {
            preconditionFailure("Module \(type) not configured in Spezi.")
        }
        return module
    }
    
    public subscript<M: Module>(_ type: M?.Type) -> M? {
        spezi.module()
    }
}

extension Application {
    public var spezi: SpeziApplicationNamespace {
        SpeziApplicationNamespace(application: self)
    }
}
