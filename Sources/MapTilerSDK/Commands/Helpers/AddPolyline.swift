//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolyline.swift
//  MapTilerSDK
//

/// Adds a polyline layer via JS helpers: `maptilersdk.helpers.addPolyline(map, options)`.
package struct AddPolyline: MTCommand {
    var options: MTPolylineLayerOptions

    package func toJS() -> JSString {
        let optionsString: JSString = options.toJSON() ?? "{}"
        return "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(optionsString));"
    }
}

/// Public options for the polyline helper, mirrors the JS PolylineLayerOptions.
public struct MTPolylineLayerOptions: Sendable, Codable {
    // CommonShapeLayerOptions
    public var layerId: String?
    public var sourceId: String?
    public var data: String
    public var beforeId: String?
    public var minzoom: Double?
    public var maxzoom: Double?
    public var outline: Bool?
    public var outlineColor: MTStringOrZoomValues?
    public var outlineWidth: MTNumberOrZoomValues?
    public var outlineOpacity: MTNumberOrZoomValues?

    // Polyline specific
    public var lineColor: MTStringOrZoomValues?
    public var lineWidth: MTNumberOrZoomValues?
    public var lineOpacity: MTNumberOrZoomValues?
    public var lineBlur: MTNumberOrZoomValues?
    public var lineGapWidth: MTNumberOrZoomValues?
    public var lineDashArray: MTDashPattern?
    public var lineCap: MTLineCap?
    public var lineJoin: MTLineJoin?
    public var outlineBlur: MTNumberOrZoomValues?

    public init(
        data: String,
        layerId: String? = nil,
        sourceId: String? = nil,
        beforeId: String? = nil,
        minzoom: Double? = nil,
        maxzoom: Double? = nil,
        outline: Bool? = nil,
        outlineColor: MTStringOrZoomValues? = nil,
        outlineWidth: MTNumberOrZoomValues? = nil,
        outlineOpacity: MTNumberOrZoomValues? = nil,
        lineColor: MTStringOrZoomValues? = nil,
        lineWidth: MTNumberOrZoomValues? = nil,
        lineOpacity: MTNumberOrZoomValues? = nil,
        lineBlur: MTNumberOrZoomValues? = nil,
        lineGapWidth: MTNumberOrZoomValues? = nil,
        lineDashArray: MTDashPattern? = nil,
        lineCap: MTLineCap? = nil,
        lineJoin: MTLineJoin? = nil,
        outlineBlur: MTNumberOrZoomValues? = nil
    ) {
        self.layerId = layerId
        self.sourceId = sourceId
        self.data = data
        self.beforeId = beforeId
        self.minzoom = minzoom
        self.maxzoom = maxzoom
        self.outline = outline
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.outlineOpacity = outlineOpacity
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.lineOpacity = lineOpacity
        self.lineBlur = lineBlur
        self.lineGapWidth = lineGapWidth
        self.lineDashArray = lineDashArray
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.outlineBlur = outlineBlur
    }
}
