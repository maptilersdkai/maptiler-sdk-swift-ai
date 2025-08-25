//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolyline.swift
//  MapTilerSDK
//

import UIKit

/// Options for polyline layer styling.
public struct MTPolylineLayerOptions: Codable, Sendable {
    /// Color of the line (or polyline).
    public var lineColor: MTColor?

    /// Width of the line (relative to screen-space).
    public var lineWidth: Double?

    /// Opacity of the line.
    public var lineOpacity: Double?

    /// How blury the line is, with `0` being no blur and `10` and beyond being quite blurry.
    public var lineBlur: Double?

    /// Draws a line casing outside of a line's actual path.
    public var lineGapWidth: Double?

    /// Sequence of line and void to create a dash pattern.
    public var lineDashArray: [Double]?

    /// The display of line endings for both the line and the outline.
    public var lineCap: MTLineCap?

    /// The display of lines when joining for both the line and the outline.
    public var lineJoin: MTLineJoin?

    /// How blury the outline is.
    public var outlineBlur: Double?

    /// Whether to add an outline layer.
    public var outline: Bool?

    /// Data source (UUID, GeoJSON URL, or content).
    public var data: String

    public init(
        data: String,
        lineColor: MTColor? = nil,
        lineWidth: Double? = 3,
        lineOpacity: Double? = 1,
        lineBlur: Double? = 0,
        lineGapWidth: Double? = 0,
        lineDashArray: [Double]? = nil,
        lineCap: MTLineCap? = .round,
        lineJoin: MTLineJoin? = .round,
        outlineBlur: Double? = 0,
        outline: Bool? = false
    ) {
        self.data = data
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.lineOpacity = lineOpacity
        self.lineBlur = lineBlur
        self.lineGapWidth = lineGapWidth
        self.lineDashArray = lineDashArray
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.outlineBlur = outlineBlur
        self.outline = outline
    }

    enum CodingKeys: String, CodingKey {
        case lineColor, lineWidth, lineOpacity, lineBlur, lineGapWidth
        case lineDashArray, lineCap, lineJoin, outlineBlur, outline, data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        data = try container.decode(String.self, forKey: .data)
        lineColor = try container.decodeIfPresent(MTColor.self, forKey: .lineColor)
        lineWidth = try container.decodeIfPresent(Double.self, forKey: .lineWidth)
        lineOpacity = try container.decodeIfPresent(Double.self, forKey: .lineOpacity)
        lineBlur = try container.decodeIfPresent(Double.self, forKey: .lineBlur)
        lineGapWidth = try container.decodeIfPresent(Double.self, forKey: .lineGapWidth)
        lineDashArray = try container.decodeIfPresent([Double].self, forKey: .lineDashArray)
        lineCap = try container.decodeIfPresent(MTLineCap.self, forKey: .lineCap)
        lineJoin = try container.decodeIfPresent(MTLineJoin.self, forKey: .lineJoin)
        outlineBlur = try container.decodeIfPresent(Double.self, forKey: .outlineBlur)
        outline = try container.decodeIfPresent(Bool.self, forKey: .outline)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(lineColor, forKey: .lineColor)
        try container.encodeIfPresent(lineWidth, forKey: .lineWidth)
        try container.encodeIfPresent(lineOpacity, forKey: .lineOpacity)
        try container.encodeIfPresent(lineBlur, forKey: .lineBlur)
        try container.encodeIfPresent(lineGapWidth, forKey: .lineGapWidth)
        try container.encodeIfPresent(lineDashArray, forKey: .lineDashArray)
        try container.encodeIfPresent(lineCap, forKey: .lineCap)
        try container.encodeIfPresent(lineJoin, forKey: .lineJoin)
        try container.encodeIfPresent(outlineBlur, forKey: .outlineBlur)
        try container.encodeIfPresent(outline, forKey: .outline)
    }
}

package struct AddPolyline: MTCommand {
    var options: MTPolylineLayerOptions

    package init(options: MTPolylineLayerOptions) {
        self.options = options
    }

    package func toJS() -> JSString {
        struct JSOptions: Codable {
            let data: String
            let lineColor: String?
            let lineWidth: Double?
            let lineOpacity: Double?
            let lineBlur: Double?
            let lineGapWidth: Double?
            let lineDashArray: [Double]?
            let lineCap: String?
            let lineJoin: String?
            let outlineBlur: Double?
            let outline: Bool?
        }

        let jsOptions = JSOptions(
            data: options.data,
            lineColor: options.lineColor?.hex,
            lineWidth: options.lineWidth,
            lineOpacity: options.lineOpacity,
            lineBlur: options.lineBlur,
            lineGapWidth: options.lineGapWidth,
            lineDashArray: options.lineDashArray,
            lineCap: options.lineCap?.rawValue,
            lineJoin: options.lineJoin?.rawValue,
            outlineBlur: options.outlineBlur,
            outline: options.outline
        )

        guard let json = jsOptions.toJSON() else {
            return ""
        }

        return "maptilersdk.helpers.addPolyline(\(MTBridge.mapObject), \(json));"
    }
}
