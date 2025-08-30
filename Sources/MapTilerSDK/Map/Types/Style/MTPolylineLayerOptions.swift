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
public struct MTPolylineLayerOptions: Codable, Sendable {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(layerId, forKey: .layerId)
        try container.encodeIfPresent(sourceId, forKey: .sourceId)
        try container.encodeIfPresent(beforeId, forKey: .beforeId)
        try container.encodeIfPresent(minzoom, forKey: .minzoom)
        try container.encodeIfPresent(maxzoom, forKey: .maxzoom)
        try container.encodeIfPresent(outline, forKey: .outline)

        try encodeColorIfPresent(outlineColor, key: .outlineColor, container: &container)
        try encodeWidthIfPresent(outlineWidth, key: .outlineWidth, container: &container)
        try encodeWidthIfPresent(outlineOpacity, key: .outlineOpacity, container: &container)
        try encodeWidthIfPresent(outlineBlur, key: .outlineBlur, container: &container)

        try encodeColorIfPresent(lineColor, key: .lineColor, container: &container)
        try encodeWidthIfPresent(lineWidth, key: .lineWidth, container: &container)
        try encodeWidthIfPresent(lineOpacity, key: .lineOpacity, container: &container)
        try encodeWidthIfPresent(lineBlur, key: .lineBlur, container: &container)
        try encodeWidthIfPresent(lineGapWidth, key: .lineGapWidth, container: &container)

        try encodeDashArrayIfPresent(lineDashArray, container: &container)

        try container.encodeIfPresent(lineCap?.rawValue, forKey: .lineCap)
        try container.encodeIfPresent(lineJoin?.rawValue, forKey: .lineJoin)
    }

    private func encodeColorIfPresent(
        _ color: MTPolylineColor?,
        key: CodingKeys,
        container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        guard let color = color else { return }
        switch color {
        case .constant(let uiColor):
            try container.encode(uiColor.toHex(), forKey: key)
        case .zoomStops(let values):
            struct ZoomColorStop: Codable {
                let zoom: Double
                let value: String
            }
            let zoomStops = values.stops.map { ZoomColorStop(zoom: $0.zoom, value: $0.value) }
            try container.encode(zoomStops, forKey: key)
        }
    }

    private func encodeWidthIfPresent(
        _ width: MTPolylineWidth?,
        key: CodingKeys,
        container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        guard let width = width else { return }
        switch width {
        case .constant(let value):
            try container.encode(value, forKey: key)
        case .zoomStops(let values):
            struct ZoomNumberStop: Codable {
                let zoom: Double
                let value: Double
            }
            let zoomStops = values.stops.map { ZoomNumberStop(zoom: $0.zoom, value: $0.value) }
            try container.encode(zoomStops, forKey: key)
        }
    }

    private func encodeDashArrayIfPresent(
        _ dashArray: MTLineDashArray?,
        container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        guard let dashArray = dashArray else { return }
        switch dashArray {
        case .array(let values):
            try container.encode(values, forKey: .lineDashArray)
        case .pattern(let pattern):
            try container.encode(pattern, forKey: .lineDashArray)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case layerId, sourceId, data, beforeId, minzoom, maxzoom, outline
        case outlineColor, outlineWidth, outlineOpacity, outlineBlur
        case lineColor, lineWidth, lineOpacity, lineBlur, lineGapWidth
        case lineDashArray, lineCap, lineJoin
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
