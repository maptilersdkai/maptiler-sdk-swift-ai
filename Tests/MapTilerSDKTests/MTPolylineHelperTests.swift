//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//

import Testing
import UIKit

@testable import MapTilerSDK

import Foundation

@Suite
struct MTPolylineHelperTests {
    @Test func addPolyline_toJS_matchesSignature() async throws {
        let options = MTPolylineLayerOptions(
            data: "74003ba7-215a-4b7e-8e26-5bbe3aa70b05",
            lineColor: MTColor(color: UIColor.red.cgColor),
            lineWidth: 4,
            lineDashArray: [4, 1],
            lineCap: .butt
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        #expect(js.contains("maptilersdk.helpers.addPolyline(map,"))
        #expect(js.contains("\"data\":\"74003ba7-215a-4b7e-8e26-5bbe3aa70b05\""))
        #expect(js.contains("\"lineWidth\":4"))
        #expect(js.contains("\"lineCap\":\"butt\""))
        #expect(js.contains("\"lineColor\":\"#FF0000\"")) // Red color hex
    }
    
    @Test func mtPolylineLayerOptions_shouldEncodeCorrectly() async throws {
        let options = MTPolylineLayerOptions(
            data: "some-trace.geojson",
            lineColor: MTColor(color: UIColor.green.cgColor),
            lineWidth: 3.5,
            lineOpacity: 0.8,
            lineBlur: 1.2,
            lineGapWidth: 0.5,
            lineDashArray: [3, 1, 1, 1],
            lineCap: .round,
            lineJoin: .round,
            outlineBlur: 0.2,
            outline: true
        )
        
        let json = options.toJSON()
        #expect(json != nil)
        
        let decoder = JSONDecoder()
        let decodedOptions = try decoder.decode(MTPolylineLayerOptions.self, from: Data(json!.utf8))
        
        #expect(options.data == decodedOptions.data)
        #expect(options.lineColor?.hex == decodedOptions.lineColor?.hex)
        #expect(options.lineWidth == decodedOptions.lineWidth)
        #expect(options.lineOpacity == decodedOptions.lineOpacity)
        #expect(options.lineBlur == decodedOptions.lineBlur)
        #expect(options.lineGapWidth == decodedOptions.lineGapWidth)
        #expect(options.lineDashArray == decodedOptions.lineDashArray)
        #expect(options.lineCap == decodedOptions.lineCap)
        #expect(options.lineJoin == decodedOptions.lineJoin)
        #expect(options.outlineBlur == decodedOptions.outlineBlur)
        #expect(options.outline == decodedOptions.outline)
    }
    
    @Test func mtPolylineLayerOptions_defaultValues_shouldBeCorrect() async throws {
        let options = MTPolylineLayerOptions(data: "test.geojson")
        
        #expect(options.data == "test.geojson")
        #expect(options.lineWidth == 3)
        #expect(options.lineOpacity == 1)
        #expect(options.lineBlur == 0)
        #expect(options.lineGapWidth == 0)
        #expect(options.lineCap == .round)
        #expect(options.lineJoin == .round)
        #expect(options.outlineBlur == 0)
        #expect(options.outline == false)
        #expect(options.lineColor == nil) // Random color selection
        #expect(options.lineDashArray == nil)
    }
    
    @Test func addPolyline_withMinimalOptions_shouldGenerateValidJS() async throws {
        let options = MTPolylineLayerOptions(data: "minimal.geojson")
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        #expect(js.contains("maptilersdk.helpers.addPolyline(map,"))
        #expect(js.contains("\"data\":\"minimal.geojson\""))
        #expect(js.hasPrefix("maptilersdk.helpers.addPolyline"))
        #expect(js.hasSuffix(");"))
    }
}
