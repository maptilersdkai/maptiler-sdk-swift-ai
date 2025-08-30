//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolylineTests.swift
//  MapTilerSDKTests
//

import XCTest
import UIKit
@testable import MapTilerSDK

final class AddPolylineTests: XCTestCase {
    
    func testAddPolylineBasicOptions() throws {
        let options = MTPolylineLayerOptions(
            data: "74003ba7-215a-4b7e-8e26-5bbe3aa70b05",
            lineColor: .constant(.red),
            lineWidth: .constant(4)
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"data\": \"74003ba7-215a-4b7e-8e26-5bbe3aa70b05\""))
        XCTAssertTrue(js.contains("\"lineColor\": \"#FF0000\""))
        XCTAssertTrue(js.contains("\"lineWidth\": 4"))
        XCTAssertTrue(js.contains("maptilersdk.helpers.addPolyline(map,"))
    }
    
    func testAddPolylineWithZoomStops() throws {
        let colorStops = ZoomStringValues(zoomStopsWithColors: [
            (zoom: 0, color: .red),
            (zoom: 10, color: .blue)
        ])
        
        let widthStops = ZoomNumberValues(zoomStops: [
            (zoom: 0, value: 2),
            (zoom: 15, value: 8)
        ])
        
        let options = MTPolylineLayerOptions(
            data: "trace.geojson",
            lineColor: .zoomStops(colorStops),
            lineWidth: .zoomStops(widthStops)
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"lineColor\": [{\"zoom\": 0.0, \"value\": \"#FF0000\"}, {\"zoom\": 10.0, \"value\": \"#0000FF\"}]"))
        XCTAssertTrue(js.contains("\"lineWidth\": [{\"zoom\": 0.0, \"value\": 2.0}, {\"zoom\": 15.0, \"value\": 8.0}]"))
    }
    
    func testAddPolylineWithDashArray() throws {
        let options = MTPolylineLayerOptions(
            data: "trace.geojson",
            lineDashArray: .array([3, 1, 1, 1])
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"lineDashArray\": [3.0, 1.0, 1.0, 1.0]"))
    }
    
    func testAddPolylineWithDashPattern() throws {
        let options = MTPolylineLayerOptions(
            data: "trace.geojson",
            lineDashArray: .pattern("____ _ ")
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"lineDashArray\": \"____ _ \""))
    }
    
    func testAddPolylineWithLineCapAndJoin() throws {
        let options = MTPolylineLayerOptions(
            data: "trace.geojson",
            lineCap: .butt,
            lineJoin: .miter
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"lineCap\": \"butt\""))
        XCTAssertTrue(js.contains("\"lineJoin\": \"miter\""))
    }
    
    func testAddPolylineWithOutline() throws {
        let options = MTPolylineLayerOptions(
            data: "trace.geojson",
            outline: true,
            outlineColor: .constant(.white),
            outlineWidth: .constant(1)
        )
        
        let command = AddPolyline(options: options)
        let js = command.toJS()
        
        XCTAssertTrue(js.contains("\"outline\": true"))
        XCTAssertTrue(js.contains("\"outlineColor\": \"#FFFFFF\""))
        XCTAssertTrue(js.contains("\"outlineWidth\": 1"))
    }
    
    func testPolylineResultDecoding() throws {
        let result = MTPolylineResult(
            polylineLayerId: "layer123",
            polylineOutlineLayerId: "outline123",
            polylineSourceId: "source123"
        )
        
        XCTAssertEqual(result.polylineLayerId, "layer123")
        XCTAssertEqual(result.polylineOutlineLayerId, "outline123")
        XCTAssertEqual(result.polylineSourceId, "source123")
    }
    
    func testZoomStringValuesWithColors() throws {
        let values = ZoomStringValues(zoomStopsWithColors: [
            (zoom: 0, color: .red),
            (zoom: 5, color: .green),
            (zoom: 10, color: .blue)
        ])
        
        XCTAssertEqual(values.stops.count, 3)
        XCTAssertEqual(values.stops[0].zoom, 0)
        XCTAssertEqual(values.stops[0].value, "#FF0000")
        XCTAssertEqual(values.stops[1].zoom, 5)
        XCTAssertEqual(values.stops[1].value, "#00FF00")
        XCTAssertEqual(values.stops[2].zoom, 10)
        XCTAssertEqual(values.stops[2].value, "#0000FF")
    }
    
    func testZoomNumberValues() throws {
        let values = ZoomNumberValues(zoomStops: [
            (zoom: 0, value: 1.0),
            (zoom: 10, value: 5.0)
        ])
        
        XCTAssertEqual(values.stops.count, 2)
        XCTAssertEqual(values.stops[0].zoom, 0)
        XCTAssertEqual(values.stops[0].value, 1.0)
        XCTAssertEqual(values.stops[1].zoom, 10)
        XCTAssertEqual(values.stops[1].value, 5.0)
    }
}