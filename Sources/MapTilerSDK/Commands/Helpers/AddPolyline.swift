//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolyline.swift
//  MapTilerSDK
//

import Foundation

package struct AddPolyline: MTCommand {
    var options: MTPolylineLayerOptions

    package func toJS() -> JSString {
        var jsonParts: [String] = []

        jsonParts.append("\"data\": \"\(options.data)\"")

        addBasicOptions(to: &jsonParts)
        addLineStyleOptions(to: &jsonParts)
        addOutlineOptions(to: &jsonParts)

        let json = "{\(jsonParts.joined(separator: ", "))}"
        return "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(json));"
    }

    private func addBasicOptions(to jsonParts: inout [String]) {
        if let layerId = options.layerId {
            jsonParts.append("\"layerId\": \"\(layerId)\"")
        }

        if let sourceId = options.sourceId {
            jsonParts.append("\"sourceId\": \"\(sourceId)\"")
        }

        if let beforeId = options.beforeId {
            jsonParts.append("\"beforeId\": \"\(beforeId)\"")
        }

        if let minzoom = options.minzoom {
            jsonParts.append("\"minzoom\": \(minzoom)")
        }

        if let maxzoom = options.maxzoom {
            jsonParts.append("\"maxzoom\": \(maxzoom)")
        }

        if let outline = options.outline {
            jsonParts.append("\"outline\": \(outline ? "true" : "false")")
        }
    }

    private func addLineStyleOptions(to jsonParts: inout [String]) {
        addColorOption(options.lineColor, key: "lineColor", to: &jsonParts)
        addNumberOption(options.lineWidth, key: "lineWidth", to: &jsonParts)
        addNumberOption(options.lineOpacity, key: "lineOpacity", to: &jsonParts)
        addNumberOption(options.lineBlur, key: "lineBlur", to: &jsonParts)
        addNumberOption(options.lineGapWidth, key: "lineGapWidth", to: &jsonParts)

        if let lineDashArray = options.lineDashArray {
            addDashArrayOption(lineDashArray, to: &jsonParts)
        }

        if let lineCap = options.lineCap {
            jsonParts.append("\"lineCap\": \"\(lineCap.rawValue)\"")
        }

        if let lineJoin = options.lineJoin {
            jsonParts.append("\"lineJoin\": \"\(lineJoin.rawValue)\"")
        }
    }

    private func addOutlineOptions(to jsonParts: inout [String]) {
        addColorOption(options.outlineColor, key: "outlineColor", to: &jsonParts)
        addNumberOption(options.outlineWidth, key: "outlineWidth", to: &jsonParts)
        addNumberOption(options.outlineOpacity, key: "outlineOpacity", to: &jsonParts)
        addNumberOption(options.outlineBlur, key: "outlineBlur", to: &jsonParts)
    }

    private func addColorOption(_ color: MTPolylineColor?, key: String, to jsonParts: inout [String]) {
        guard let color = color else { return }
        switch color {
        case .constant(let colorValue):
            jsonParts.append("\"\(key)\": \"\(colorValue.toHex())\"")
        case .zoomStops(let values):
            let stopsJson = values.stops.map {
                "{\"zoom\": \($0.zoom), \"value\": \"\($0.value)\"}"
            }.joined(separator: ", ")
            jsonParts.append("\"\(key)\": [\(stopsJson)]")
        }
    }

    private func addNumberOption(_ value: MTPolylineWidth?, key: String, to jsonParts: inout [String]) {
        guard let value = value else { return }
        switch value {
        case .constant(let numberValue):
            jsonParts.append("\"\(key)\": \(numberValue)")
        case .zoomStops(let values):
            let stopsJson = values.stops.map {
                "{\"zoom\": \($0.zoom), \"value\": \($0.value)}"
            }.joined(separator: ", ")
            jsonParts.append("\"\(key)\": [\(stopsJson)]")
        }
    }

    private func addDashArrayOption(_ dashArray: MTLineDashArray, to jsonParts: inout [String]) {
        switch dashArray {
        case .array(let values):
            let arrayJson = values.map { "\($0)" }.joined(separator: ", ")
            jsonParts.append("\"lineDashArray\": [\(arrayJson)]")
        case .pattern(let pattern):
            jsonParts.append("\"lineDashArray\": \"\(pattern)\"")
        }
    }
}
