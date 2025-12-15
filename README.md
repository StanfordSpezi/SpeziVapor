<!--
                  
This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

# Spezi Vapor

[![Build and Test](https://github.com/StanfordSpezi/SpeziVapor/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordSpezi/SpeziVapor/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/StanfordSpezi/SpeziVapor/branch/main/graph/badge.svg?token=X7BQYSUKOH)](https://codecov.io/gh/StanfordSpezi/SpeziVapor)
[![DOI](https://zenodo.org/badge/TODO)](https://zenodo.org/badge/latestdoi/TODO) 
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziVapor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StanfordSpezi/SpeziVapor)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziVapor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/StanfordSpezi/SpeziVapor)



## Overview

SpeziVapor provides seamless integration between the Spezi framework and Vapor web applications, allowing you to leverage Spezi's modular architecture in your server-side Swift code.

## Configuration

Configure Spezi during your Vapor application setup:

```swift
import SpeziVapor
import Vapor

func configure(_ app: Application) throws {
    app.spezi.configure(standard: MyStandard()) {
        ModuleA()
        ModuleB()
    }
}
```

> [!IMPORTANT]
> Spezi must be configured before accessing any modules. Attempting to access modules before configuration will result in a runtime error.

## Usage

Access configured modules in your route handlers via `req.spezi`:

```swift
app.get("users") { req async throws -> [UserData] in
    let dataModule = req.spezi[DataModule.self]
    return dataModule.getAllUsers()
}
```

## Thread Safety

All modules accessed through SpeziVapor must conform to `Module` and `Sendable` for safe concurrent access:

```swift
actor MyModule: Module, Sendable {
    func getData() -> [String] {
        // ...
    }
}
```

> [!WARNING]
> Loading or unloading modules after initial configuration can lead to data races. Configure all modules once during application startup.


## Installation

The project can be added to your Xcode project or Swift Package using the [Swift Package Manager](https://github.com/apple/swift-package-manager).

**Xcode:** For an Xcode project, follow the instructions on [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

**Swift Package:** You can follow the [Swift Package Manager documentation about defining dependencies](https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#defining-dependencies) to add this project as a dependency to your Swift Package.


## License
This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/SpeziVapor/tree/main/LICENSES) for more information.


## Contributors
This project is developed as part of the Stanford Mussallem Center for Biodesign at Stanford University.
See [CONTRIBUTORS.md](https://github.com/StanfordSpezi/SpeziVapor/tree/main/CONTRIBUTORS.md) for a full list of all Spezi Vapor contributors.

![Stanford Mussallem Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Mussallem Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
