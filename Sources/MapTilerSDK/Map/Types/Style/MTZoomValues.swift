//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTZoomValues.swift
//  MapTilerSDK
//

import UIKit

/// Array of string values that depend on zoom level
public struct ZoomStringValues: Codable, Sendable {
    /// Zoom level stops
    public let stops: [ZoomStringStop]

    /// Zoom level and its corresponding string value
    public struct ZoomStringStop: Codable, Sendable {
        /// Zoom level
        public let zoom: Double
        /// Value for the given zoom level
        public let value: String

        public init(zoom: Double, value: String) {
            self.zoom = zoom
            self.value = value
        }
    }

    public init(stops: [ZoomStringStop]) {
        self.stops = stops
    }

    public init(zoomStops: [(zoom: Double, value: String)]) {
        self.stops = zoomStops.map { ZoomStringStop(zoom: $0.zoom, value: $0.value) }
    }

    public init(zoomStopsWithColors: [(zoom: Double, color: UIColor)]) {
        self.stops = zoomStopsWithColors.map { ZoomStringStop(zoom: $0.zoom, value: $0.color.toHex()) }
    }
}

/// Array of number values that depend on zoom level
public struct ZoomNumberValues: Codable, Sendable {
    /// Zoom level stops
    public let stops: [ZoomNumberStop]

    /// Zoom level and its corresponding number value
    public struct ZoomNumberStop: Codable, Sendable {
        /// Zoom level
        public let zoom: Double
        /// Value for the given zoom level
        public let value: Double

        public init(zoom: Double, value: Double) {
            self.zoom = zoom
            self.value = value
        }
    }

    public init(stops: [ZoomNumberStop]) {
        self.stops = stops
    }

    public init(zoomStops: [(zoom: Double, value: Double)]) {
        self.stops = zoomStops.map { ZoomNumberStop(zoom: $0.zoom, value: $0.value) }
    }
}

extension ZoomStringValues {
    /// Creates a constant value for all zoom levels
    public static func constant(_ value: String) -> ZoomStringValues {
        return ZoomStringValues(stops: [ZoomStringStop(zoom: 0, value: value)])
    }

    /// Creates a constant color value for all zoom levels
    public static func constant(color: UIColor) -> ZoomStringValues {
        return ZoomStringValues(stops: [ZoomStringStop(zoom: 0, value: color.toHex())])
    }
}

extension ZoomNumberValues {
    /// Creates a constant value for all zoom levels
    public static func constant(_ value: Double) -> ZoomNumberValues {
        return ZoomNumberValues(stops: [ZoomNumberStop(zoom: 0, value: value)])
    }
}
