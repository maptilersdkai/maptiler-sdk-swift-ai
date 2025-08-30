//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTMapView+Helpers.swift
//  MapTilerSDK
//

import UIKit

@MainActor
public extension MTMapView {
    /// Add a polyline to the map from various sources with built-in styling
    ///
    /// Compatible sources:
    /// - UUID of a MapTiler dataset
    /// - GeoJSON from URL
    /// - GeoJSON content as string
    /// - GPX content as string
    /// - GPX file from URL
    /// - KML content from string
    /// - KML from URL
    ///
    /// - Parameter options: Configuration options for the polyline layer
    /// - Parameter completion: Completion handler with the result containing layer IDs
    func addPolyline(
        options: MTPolylineLayerOptions,
        completion: @escaping (Result<MTPolylineResult, MTError>) -> Void
    ) {
        guard isInitialized else {
            completion(.failure(MTError.bridgeNotLoaded))
            return
        }

        runCommandWithPolylineResultReturnValue(AddPolyline(options: options), completion: completion)
    }

    /// Add a polyline to the map from various sources with built-in styling (async)
    ///
    /// Compatible sources:
    /// - UUID of a MapTiler dataset
    /// - GeoJSON from URL
    /// - GeoJSON content as string
    /// - GPX content as string
    /// - GPX file from URL
    /// - KML content from string
    /// - KML from URL
    ///
    /// - Parameter options: Configuration options for the polyline layer
    /// - Returns: Result containing the layer IDs
    func addPolyline(options: MTPolylineLayerOptions) async throws -> MTPolylineResult {
        guard isInitialized else {
            throw MTError.bridgeNotLoaded
        }

        return try await withCheckedThrowingContinuation { continuation in
            addPolyline(options: options) { result in
                continuation.resume(with: result)
            }
        }
    }
}

@MainActor
public extension MTMapView {
    /// Convenience method to add a polyline with simplified parameters
    ///
    /// - Parameters:
    ///   - data: Data source (UUID, URL, or content string)
    ///   - lineColor: Color of the line (default: random)
    ///   - lineWidth: Width of the line (default: 3)
    ///   - completion: Completion handler with the result
    func addPolyline(
        data: String,
        lineColor: UIColor? = nil,
        lineWidth: Double? = nil,
        completion: @escaping (Result<MTPolylineResult, MTError>) -> Void
    ) {
        let options = MTPolylineLayerOptions(
            data: data,
            lineColor: lineColor.map { MTPolylineColor.constant($0) },
            lineWidth: lineWidth.map { MTPolylineWidth.constant($0) }
        )
        addPolyline(options: options, completion: completion)
    }

    /// Convenience method to add a polyline with simplified parameters (async)
    ///
    /// - Parameters:
    ///   - data: Data source (UUID, URL, or content string)
    ///   - lineColor: Color of the line (default: random)
    ///   - lineWidth: Width of the line (default: 3)
    /// - Returns: Result containing the layer IDs
    func addPolyline(
        data: String,
        lineColor: UIColor? = nil,
        lineWidth: Double? = nil
    ) async throws -> MTPolylineResult {
        let options = MTPolylineLayerOptions(
            data: data,
            lineColor: lineColor.map { MTPolylineColor.constant($0) },
            lineWidth: lineWidth.map { MTPolylineWidth.constant($0) }
        )
        return try await addPolyline(options: options)
    }

}
