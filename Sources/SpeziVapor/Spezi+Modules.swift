//
// This source file is part of the TemplatePackage open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) import Spezi

extension Spezi {
    func module<M: Module>() -> M? {
        modules.first { $0 is M } as? M
    }
}
