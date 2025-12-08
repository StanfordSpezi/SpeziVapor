# ``SpeziVaporTesting``

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Test functionality for the SpeziVapor package.

## Overview

This package provides testing extensions for the SpeziVapor package.


### Testing Vapor Applications

Integration tests are crucial for verifying that your Spezi [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module)s interact correctly with the Vapor environment and the application lifecycle.
The `SpeziVaporTesting` package simplifies this process by providing helper methods to spin up a Vapor `Application` and configure the Spezi environment.
Use ``withSpeziVaporApp(routes:standard:modules:_:)`` or ``withSpeziVaporApp(routes:modules:_:)`` to run tests within a fully configured Spezi environment.
Below is a short code example that demonstrates this functionality.

```swift
import SpeziVaporTesting
import Testing

@Test
func speziVaporTesting() async throw {
    try await withSpeziVaporApp(routes: routes, standard: TestStandard(), modules: { TestModule() }) { app in
        try await app.testing().test(.GET, "path", afterResponse: { res in
            #expect(res.status == .ok)
        })
    }
}
```

