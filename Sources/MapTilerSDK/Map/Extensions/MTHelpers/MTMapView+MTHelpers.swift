//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTMapView+MTHelpers.swift
//  MapTilerSDK
//

import Foundation

extension MTMapView {
    /// Adds a polyline with built-in styling using the JS helpers.
    /// - Parameters:
    ///   - options: Polyline helper options. `data` must be provided.
    ///   - completionHandler: A handler block to execute when function finishes.
    @available(iOS, deprecated: 16.0, message: "Prefer the async version for modern concurrency handling")
    public func addPolyline(
        options: MTPolylineLayerOptions,
        completionHandler: ((Result<Void, MTError>) -> Void)? = nil
    ) {
        runCommand(AddPolyline(options: options), completion: completionHandler)
    }

    /// Adds a polyline with built-in styling using the JS helpers.
    /// - Parameter options: Polyline helper options. `data` must be provided.
    public func addPolyline(options: MTPolylineLayerOptions) async {
        await withCheckedContinuation { continuation in
            addPolyline(options: options) { _ in
                continuation.resume()
            }
        }
    }
}

