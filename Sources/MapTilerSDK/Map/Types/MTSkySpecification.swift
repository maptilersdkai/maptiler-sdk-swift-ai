//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTSkySpecification.swift
//  MapTilerSDK
//

import Foundation

/// Sky style specification.
public struct MTSkySpecification: Sendable, Codable {
    /// The base sky color. Defaults to `#88C6FC`.
    public var skyColor: MTColor?

    /// The base color at the horizon. Defaults to `#ffffff`.
    public var horizonColor: MTColor?

    /// The base color for the fog. Requires 3D terrain. Defaults to `#ffffff`.
    public var fogColor: MTColor?

    /// How to blend the fog over the 3D terrain. Where `0` is the map center and `1` is the horizon.
    /// Optional number in range `[0, 1]`. Defaults to `0.5`.
    public var fogGroundBlend: Double?

    /// Blend fog vs horizon color. `0`: horizon only; `1`: fog only.
    /// Optional number in range `[0, 1]`. Defaults to `0.8`.
    public var horizonFogBlend: Double?

    /// Blend sky vs horizon color. `1`: blend mid‑sky; `0`: no blend (sky only).
    /// Optional number in range `[0, 1]`. Defaults to `0.8`.
    public var skyHorizonBlend: Double?

    /// Controls atmosphere visibility. `1`: visible; `0`: hidden.
    /// Best with globe projection.
    /// Optional number in range `[0, 1]`. Defaults to `0.8`.
    public var atmosphereBlend: Double?

    public init(
        skyColor: MTColor? = nil,
        horizonColor: MTColor? = nil,
        fogColor: MTColor? = nil,
        fogGroundBlend: Double? = nil,
        horizonFogBlend: Double? = nil,
        skyHorizonBlend: Double? = nil,
        atmosphereBlend: Double? = nil
    ) {
        self.skyColor = skyColor
        self.horizonColor = horizonColor
        self.fogColor = fogColor
        self.fogGroundBlend = fogGroundBlend
        self.horizonFogBlend = horizonFogBlend
        self.skyHorizonBlend = skyHorizonBlend
        self.atmosphereBlend = atmosphereBlend
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let skyColor {
            try container.encode(skyColor.hex, forKey: .skyColor)
        }
        if let horizonColor {
            try container.encode(horizonColor.hex, forKey: .horizonColor)
        }
        if let fogColor {
            try container.encode(fogColor.hex, forKey: .fogColor)
        }
        if let fogGroundBlend {
            try container.encode(fogGroundBlend, forKey: .fogGroundBlend)
        }
        if let horizonFogBlend {
            try container.encode(horizonFogBlend, forKey: .horizonFogBlend)
        }
        if let skyHorizonBlend {
            try container.encode(skyHorizonBlend, forKey: .skyHorizonBlend)
        }
        if let atmosphereBlend {
            try container.encode(atmosphereBlend, forKey: .atmosphereBlend)
        }
    }

    enum CodingKeys: String, CodingKey {
        case skyColor = "sky-color"
        case horizonColor = "horizon-color"
        case fogColor = "fog-color"
        case fogGroundBlend = "fog-ground-blend"
        case horizonFogBlend = "horizon-fog-blend"
        case skyHorizonBlend = "sky-horizon-blend"
        case atmosphereBlend = "atmosphere-blend"
    }
}
