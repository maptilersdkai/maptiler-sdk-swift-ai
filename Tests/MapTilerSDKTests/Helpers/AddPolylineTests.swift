//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//

import Testing
@testable import MapTilerSDK

@Suite
struct AddPolylineTests {
    @Test func addPolyline_minimal_toJS_matches() async throws {
        let options = MTPolylineLayerOptions(data: "some-trace.geojson")
        let json = options.toJSON() ?? "{}"
        let expected = "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(json));"

        #expect(AddPolyline(options: options).toJS() == expected)
    }

    @Test func addPolyline_custom_toJS_matches() async throws {
        let options = MTPolylineLayerOptions(
            data: "74003ba7-215a-4b7e-8e26-5bbe3aa70b05",
            lineColor: .constant("#FF6666"),
            lineWidth: .constant(4),
            lineDashArray: .pattern("____ _ "),
            lineCap: .butt
        )

        // JSON with sorted keys: data, lineCap, lineColor, lineDashArray, lineWidth
        let expectedJSON = "{" +
            "\"data\":\"74003ba7-215a-4b7e-8e26-5bbe3aa70b05\"," +
            "\"lineCap\":\"butt\"," +
            "\"lineColor\":\"#FF6666\"," +
            "\"lineDashArray\":\"____ _ \"," +
            "\"lineWidth\":4" +
        "}"

        let expected = "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(expectedJSON));"

        #expect(AddPolyline(options: options).toJS() == expected)
    }
}
