//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTPolylineLayerOptions.swift
//  MapTilerSDK
//

import UIKit

/// Options for adding a polyline layer using the helper method
public struct MTPolylineLayerOptions: Sendable {
    /// ID to give to the layer. If not provided, an auto-generated ID will be created.
    public let layerId: String?

    /// ID to give to the geojson source. If not provided, an auto-generated ID will be created.
    public let sourceId: String?

    /// A geojson FeatureCollection URL, GPX/KML content/URL, or UUID of a MapTiler Cloud dataset.
    public let data: String

    /// The ID of an existing layer to insert the new layer before.
    public let beforeId: String?

    /// Zoom level at which it starts to show. Default: 0
    public let minzoom: Double?

    /// Zoom level after which it no longer shows. Default: 22
    public let maxzoom: Double?

    /// Whether or not to add an outline. Default: false
    public let outline: Bool?

    /// Color of the outline. Applies only if outline is true. Default: white
    public let outlineColor: MTPolylineColor?

    /// Width of the outline. Applies only if outline is true. Default: 1
    public let outlineWidth: MTPolylineWidth?

    /// Opacity of the outline. Applies only if outline is true. Default: 1
    public let outlineOpacity: MTPolylineOpacity?

    /// How blurry the outline is. Applies only if outline is true. Default: 0
    public let outlineBlur: MTPolylineOpacity?

    /// Color of the line. Default: randomly picked color
    public let lineColor: MTPolylineColor?

    /// Width of the line. Default: 3
    public let lineWidth: MTPolylineWidth?

    /// Opacity of the line. Default: 1
    public let lineOpacity: MTPolylineOpacity?

    /// How blurry the line is. Default: 0
    public let lineBlur: MTPolylineOpacity?

    /// Line casing outside of a line's actual path. Default: 0
    public let lineGapWidth: MTPolylineWidth?

    /// Dash pattern for the line. Default: no dash pattern
    public let lineDashArray: MTLineDashArray?

    /// The display of line endings. Default: round
    public let lineCap: MTLineCap?

    /// The display of lines when joining. Default: round
    public let lineJoin: MTLineJoin?

    public init(
        data: String,
        layerId: String? = nil,
        sourceId: String? = nil,
        beforeId: String? = nil,
        minzoom: Double? = nil,
        maxzoom: Double? = nil,
        outline: Bool? = nil,
        outlineColor: MTPolylineColor? = nil,
        outlineWidth: MTPolylineWidth? = nil,
        outlineOpacity: MTPolylineOpacity? = nil,
        outlineBlur: MTPolylineOpacity? = nil,
        lineColor: MTPolylineColor? = nil,
        lineWidth: MTPolylineWidth? = nil,
        lineOpacity: MTPolylineOpacity? = nil,
        lineBlur: MTPolylineOpacity? = nil,
        lineGapWidth: MTPolylineWidth? = nil,
        lineDashArray: MTLineDashArray? = nil,
        lineCap: MTLineCap? = nil,
        lineJoin: MTLineJoin? = nil
    ) {
        self.data = data
        self.layerId = layerId
        self.sourceId = sourceId
        self.beforeId = beforeId
        self.minzoom = minzoom
        self.maxzoom = maxzoom
        self.outline = outline
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.outlineOpacity = outlineOpacity
        self.outlineBlur = outlineBlur
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.lineOpacity = lineOpacity
        self.lineBlur = lineBlur
        self.lineGapWidth = lineGapWidth
        self.lineDashArray = lineDashArray
        self.lineCap = lineCap
        self.lineJoin = lineJoin
    }
}

/// Color value that can be constant or zoom-dependent
public enum MTPolylineColor: Codable, Sendable {
    case constant(UIColor)
    case zoomStops(ZoomStringValues)

    public init(color: UIColor) {
        self = .constant(color)
    }

    public init(zoomStopsWithColors: [(zoom: Double, color: UIColor)]) {
        self = .zoomStops(ZoomStringValues(zoomStopsWithColors: zoomStopsWithColors))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .constant(let color):
            try container.encode(color.toHex())
        case .zoomStops(let values):
            try container.encode(values)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let colorString = try? container.decode(String.self) {
            guard let color = UIColor(hex: colorString) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid color string: \(colorString)"
                ))
            }
            self = .constant(color)
        } else {
            let values = try container.decode(ZoomStringValues.self)
            self = .zoomStops(values)
        }
    }
}

/// Width/opacity value that can be constant or zoom-dependent
public enum MTPolylineWidth: Codable, Sendable {
    case constant(Double)
    case zoomStops(ZoomNumberValues)

    public init(width: Double) {
        self = .constant(width)
    }

    public init(zoomStops: [(zoom: Double, value: Double)]) {
        self = .zoomStops(ZoomNumberValues(zoomStops: zoomStops))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .constant(let value):
            try container.encode(value)
        case .zoomStops(let values):
            try container.encode(values)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self) {
            self = .constant(value)
        } else {
            let values = try container.decode(ZoomNumberValues.self)
            self = .zoomStops(values)
        }
    }
}

/// Opacity value that can be constant or zoom-dependent
public typealias MTPolylineOpacity = MTPolylineWidth

/// Dash array that can be an array of numbers or a string pattern
public enum MTLineDashArray: Codable, Sendable {
    case array([Double])
    case pattern(String)

    public init(array: [Double]) {
        self = .array(array)
    }

    public init(pattern: String) {
        self = .pattern(pattern)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let values):
            try container.encode(values)
        case .pattern(let pattern):
            try container.encode(pattern)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let values = try? container.decode([Double].self) {
            self = .array(values)
        } else {
            let pattern = try container.decode(String.self)
            self = .pattern(pattern)
        }
    }
}
