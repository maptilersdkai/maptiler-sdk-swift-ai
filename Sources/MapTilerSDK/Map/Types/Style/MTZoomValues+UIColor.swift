//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTZoomValues+UIColor.swift
//  MapTilerSDK
//

import UIKit

public extension MTStringOrZoomValues {
    /// Convenience to create a constant color from a UIColor.
    static func color(_ color: UIColor) -> Self {
        .constant(color.toHex())
    }

    /// Convenience to create zoom-dependent color stops from UIColors.
    static func zoomStopsWithColors(_ stops: [(zoom: Double, color: UIColor)]) -> Self {
        .zoom(stops.map { MTZoomStringStop(zoom: $0.zoom, value: $0.color.toHex()) })
    }
}
