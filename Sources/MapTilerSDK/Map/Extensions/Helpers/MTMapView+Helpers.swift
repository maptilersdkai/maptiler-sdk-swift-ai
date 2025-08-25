//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTMapView+Helpers.swift
//  MapTilerSDK
//

import Foundation

public extension MTMapView {
    /// Adds a polyline to the map from various sources and with builtin styling.
    /// - Parameters:
    ///   - options: Polyline Layer Helper options.
    ///   - completionHandler: A handler block to execute when function finishes.
    @available(iOS, deprecated: 16.0, message: "Prefer the async version for modern concurrency handling")
    func addPolyline(
        options: MTPolylineLayerOptions,
        completionHandler: ((Result<Void, MTError>) -> Void)? = nil
    ) {
        runCommand(AddPolyline(options: options), completion: completionHandler)
    }

    /// Adds a polyline to the map from various sources and with builtin styling.
    /// - Parameters:
    ///   - options: Polyline Layer Helper options.
    func addPolyline(options: MTPolylineLayerOptions) async {
        await withCheckedContinuation { continuation in
            addPolyline(options: options) { _ in
                continuation.resume()
            }
        }
    }
}

