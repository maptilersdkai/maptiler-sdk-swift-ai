//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolyline.swift
//  MapTilerSDK
//

import Foundation

/// Options for Polyline Layer Helper.
public struct MTPolylineLayerOptions: Sendable, Codable {
    /// Dataset UUID, URL (relative/absolute), or inlined content identifier.
    public var data: String

    /// Color of the line (hex string).
    public var lineColor: MTColor?

    /// Width of the line (screen-space).
    public var lineWidth: Double?

    /// Opacity of the line [0,1].
    public var lineOpacity: Double?

    /// Blur amount for the line.
    public var lineBlur: Double?

    /// Gap width for casing effect.
    public var lineGapWidth: Double?

    /// Dash pattern definition.
    public var lineDashArray: MTLineDashArray?

    /// Line cap style.
    public var lineCap: MTLineCap?

    /// Line join style.
    public var lineJoin: MTLineJoin?

    /// Whether to add an outline layer.
    public var outline: Bool?

    /// Blur amount for the outline.
    public var outlineBlur: Double?

    public init(
        data: String,
        lineColor: MTColor? = nil,
        lineWidth: Double? = nil,
        lineOpacity: Double? = nil,
        lineBlur: Double? = nil,
        lineGapWidth: Double? = nil,
        lineDashArray: MTLineDashArray? = nil,
        lineCap: MTLineCap? = nil,
        lineJoin: MTLineJoin? = nil,
        outline: Bool? = nil,
        outlineBlur: Double? = nil
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
        self.outline = outline
        self.outlineBlur = outlineBlur
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(data, forKey: .data)

        if let lineColor { try container.encode(lineColor.hex, forKey: .lineColor) }
        if let lineWidth { try container.encode(lineWidth, forKey: .lineWidth) }
        if let lineOpacity { try container.encode(lineOpacity, forKey: .lineOpacity) }
        if let lineBlur { try container.encode(lineBlur, forKey: .lineBlur) }
        if let lineGapWidth { try container.encode(lineGapWidth, forKey: .lineGapWidth) }
        if let lineDashArray { try container.encode(lineDashArray, forKey: .lineDashArray) }
        if let lineCap { try container.encode(lineCap.rawValue, forKey: .lineCap) }
        if let lineJoin { try container.encode(lineJoin.rawValue, forKey: .lineJoin) }
        if let outline { try container.encode(outline, forKey: .outline) }
        if let outlineBlur { try container.encode(outlineBlur, forKey: .outlineBlur) }
    }

    enum CodingKeys: String, CodingKey {
        case data
        case lineColor
        case lineWidth
        case lineOpacity
        case lineBlur
        case lineGapWidth
        case lineDashArray
        case lineCap
        case lineJoin
        case outline
        case outlineBlur
    }
}

package struct AddPolyline: MTCommand {
    var options: MTPolylineLayerOptions

    package func toJS() -> JSString {
        let json: JSString = options.toJSON() ?? "{}"
        return "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(json));"
    }
}
