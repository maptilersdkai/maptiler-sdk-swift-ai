//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//

import Testing
@testable import MapTilerSDK

@Suite
struct MTHelpersTests {
    @Test func addPolyline_toJS_matchesSignature_minimal() async throws {
        let opts = MTPolylineLayerOptions(data: "some-trace.geojson")
        let cmd = AddPolyline(options: opts)
        #expect(cmd.toJS() == "maptilersdk.helpers.addPolyline(map, {\"data\":\"some-trace.geojson\"});")
    }
}

