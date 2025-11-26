//
// This source file is part of the TemplatePackage open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import SpeziVapor
import Testing


@MainActor
@Suite("Spezi Vapor Configuration Test", .serialized)
struct SpeziVaporConfigurationTest {
    @Test
    func accessingSpeziBeforeConfiguration() async throws {
        await #expect(processExitsWith: .failure) {
            try await withApp { app in
                _ = app.spezi.spezi
            }
        }
    }
    
    @Test
    func accessingSpeziAfterConfiguration() async throws {
        try await withSpeziApp(standard: TestStandard(), modules: [TestModule()]) { app in
            #expect(app.spezi.spezi != nil)
        }
    }
    
    @Test
    func moduleConfigureIsCalled() async throws {
        try await confirmation { confirmation in
            try await withSpeziApp(standard: TestStandard(), modules: { TestModule(confirmation: confirmation) }) { _ in }
        }
    }
    
    @Test
    func accessingConfiguredModule() async throws {
        let testModule = TestModule()
        try await withSpeziApp(standard: TestStandard(), modules: [testModule]) { app in
            #expect(app.spezi[TestModule.self] === testModule)
            #expect(app.spezi[TestModule?.self] === testModule)
            #expect(app.spezi[TestModule.self] !== TestModule())
            #expect(app.spezi[TestModule?.self] !== TestModule())
        }
    }
    
    @Test
    func accessingUnconfiguredModule() async throws {
        await #expect(processExitsWith: .failure) {
            try await withSpeziApp(standard: TestStandard(), modules: []) { app in
                #expect(app.spezi[TestModule?.self] == nil)
                _ = app.spezi[TestModule.self]
            }
        }
    }
}
