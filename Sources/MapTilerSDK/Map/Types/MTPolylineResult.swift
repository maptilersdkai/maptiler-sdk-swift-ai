//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTPolylineResult.swift
//  MapTilerSDK
//

/// Result from adding a polyline layer
public struct MTPolylineResult: Codable, Sendable {
    /// ID of the main polyline layer
    public let polylineLayerId: String

    /// ID of the outline layer (empty string if no outline)
    public let polylineOutlineLayerId: String

    /// ID of the data source
    public let polylineSourceId: String

    public init(polylineLayerId: String, polylineOutlineLayerId: String, polylineSourceId: String) {
        self.polylineLayerId = polylineLayerId
        self.polylineOutlineLayerId = polylineOutlineLayerId
        self.polylineSourceId = polylineSourceId
    }
}
