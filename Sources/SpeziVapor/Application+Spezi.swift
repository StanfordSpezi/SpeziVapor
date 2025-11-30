//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


@_spi(APISupport) import Spezi
import Vapor


typealias _Spezi = Spezi // swiftlint:disable:this type_name

extension Application {
    private enum SpeziStorageKey: StorageKey {
        typealias Value = _Spezi
    }
    
    /// A namespace for accessing and configuring Spezi within a Vapor application.
    ///
    /// Use this struct to configure Spezi modules during application startup and to access
    /// configured modules throughout your application.
    ///
    /// ## Configuration
    ///
    /// Configure Spezi in your application's `configure` function:
    ///
    /// ```swift
    /// func configure(_ app: Application) throws {
    ///     app.spezi.configure(standard: MyStandard()) {
    ///         ModuleA()
    ///         ModuleB()
    ///     }
    /// }
    /// ```
    ///
    /// ## Module Access
    ///
    /// Access configured modules using the subscript:
    ///
    /// ```swift
    /// let myModule = app.spezi[MyModule.self]
    /// ```
    public struct Spezi: Sendable {
        private let application: Application
        
        var spezi: _Spezi {
            guard let spezi = application.storage[SpeziStorageKey.self] else {
                preconditionFailure("Spezi not configured. Ensure Spezi is added to Application storage before use.")
            }
            return spezi
        }

        init(application: Application) {
            self.application = application
        }
        
        /// Configures Spezi with a custom standard and a collection of modules.
        ///
        /// Call this method once during application startup to initialize Spezi.
        ///
        /// - Parameters:
        ///   - standard: The standard to use for Spezi configuration.
        ///   - modules: A result builder closure that returns the modules to configure.
        @MainActor
        public func configure<S: Standard>(standard: S, @ModuleBuilder _ modules: () -> ModuleCollection) {
            application.storage[SpeziStorageKey.self] = _Spezi(from: Configuration(standard: standard, modules))
        }

        /// Configures Spezi with the default standard and a collection of modules.
        ///
        /// Call this method once during application startup to initialize Spezi.
        ///
        /// - Parameter modules: A result builder closure that returns the modules to configure.
        @MainActor
        public func configure(@ModuleBuilder _ modules: () -> ModuleCollection) {
            configure(standard: DefaultStandard(), modules)
        }
        
        /// Accesses a configured module by its type.
        ///
        /// - Parameter type: The type of the module to retrieve.
        /// - Returns: The configured module instance.
        /// - Precondition: The module must be configured, otherwise a `preconditionFailure` is triggered.
        public subscript<M: Module & Sendable>(_: M.Type) -> M {
            guard let module: M = self[M?.self] else {
                preconditionFailure("Module \(M.self) not configured in Spezi.")
            }
            return module
        }
        
        /// Optionally accesses a configured module by its type.
        ///
        /// - Parameter type: The optional type of the module to retrieve.
        /// - Returns: The configured module instance, or `nil` if not configured.
        public subscript<M: Module & Sendable>(_: M?.Type) -> M? {
            spezi._module(M.self)
        }
    }
    
    /// Access Spezi configuration and modules.
    public var spezi: Spezi {
        Spezi(application: self)
    }
}
