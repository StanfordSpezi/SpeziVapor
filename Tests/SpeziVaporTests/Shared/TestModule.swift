//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import Testing


final class TestModule: Module {
    let confirmation: Confirmation?
    
    init(confirmation: Confirmation? = nil) {
        self.confirmation = confirmation
    }
    
    
    func configure() {
        confirmation?()
    }
}
