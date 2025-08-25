//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//

import Testing
@testable import MapTilerSDK

@Suite
struct MTSkyTests {
    @Test func setSky_toJS_matchesSignature_minimal() async throws {
        let spec = MTSkySpecification(atmosphereBlend: 1.0)
        let command = SetSky(sky: spec, options: nil)
        #expect(command.toJS() == "map.setSky({\"atmosphere-blend\":1});")
    }
}

