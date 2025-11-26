//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziVapor
import VaporTesting


@MainActor
func withSpeziApp(
    standard: Standard,
    @ModuleBuilder modules: () -> ModuleCollection,
    _ test: (Application) async throws -> Void
) async throws {
    let app = try await Application.make(.testing)
    do {
        app.spezi.configure(standard: standard, modules)
        try routes(app)
        try await test(app)
    } catch {
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}

@MainActor
func withSpeziApp(
    standard: Standard,
    modules: [any Module],
    _ test: (Application) async throws -> Void
) async throws {
    let app = try await Application.make(.testing)
    do {
        app.spezi.configure(standard: standard, modules: modules)
        try routes(app)
        try await test(app)
    } catch {
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}

func withApp(
    _ test: (Application) async throws -> Void
) async throws {
    let app = try await Application.make(.testing)
    do {
        try await test(app)
    } catch {
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}
