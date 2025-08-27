//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTZoomValues.swift
//  MapTilerSDK
//

import Foundation

/// A stop describing a string value at a specific zoom level.
public struct MTZoomStringStop: Sendable, Codable {
    public let zoom: Double
    public let value: String

    public init(zoom: Double, value: String) {
        self.zoom = zoom
        self.value = value
    }
}

/// A stop describing a numeric value at a specific zoom level.
public struct MTZoomNumberStop: Sendable, Codable {
    public let zoom: Double
    public let value: Double

    public init(zoom: Double, value: Double) {
        self.zoom = zoom
        self.value = value
    }
}

/// Union wrapper for a constant string or zoom-dependent string values.
public enum MTStringOrZoomValues: Sendable, Codable {
    case constant(String)
    case zoom([MTZoomStringStop])

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .constant(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .zoom(let stops):
            var container = encoder.singleValueContainer()
            try container.encode(stops)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .constant(string)
        } else if let stops = try? container.decode([MTZoomStringStop].self) {
            self = .zoom(stops)
        } else {
            throw DecodingError.typeMismatch(
                MTStringOrZoomValues.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported MTStringOrZoomValues type")
            )
        }
    }
}

/// Union wrapper for a constant number or zoom-dependent numeric values.
public enum MTNumberOrZoomValues: Sendable, Codable {
    case constant(Double)
    case zoom([MTZoomNumberStop])

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .constant(let number):
            var container = encoder.singleValueContainer()
            try container.encode(number)
        case .zoom(let stops):
            var container = encoder.singleValueContainer()
            try container.encode(stops)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let number = try? container.decode(Double.self) {
            self = .constant(number)
        } else if let stops = try? container.decode([MTZoomNumberStop].self) {
            self = .zoom(stops)
        } else {
            throw DecodingError.typeMismatch(
                MTNumberOrZoomValues.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported MTNumberOrZoomValues type")
            )
        }
    }
}

/// Union wrapper for dash arrays encoded either as an array or a compact pattern string.
public enum MTDashPattern: Sendable, Codable {
    case array([Double])
    case pattern(String)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .array(let values):
            var container = encoder.singleValueContainer()
            try container.encode(values)
        case .pattern(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let values = try? container.decode([Double].self) {
            self = .array(values)
        } else if let string = try? container.decode(String.self) {
            self = .pattern(string)
        } else {
            throw DecodingError.typeMismatch(
                MTDashPattern.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported MTDashPattern type")
            )
        }
    }
}

