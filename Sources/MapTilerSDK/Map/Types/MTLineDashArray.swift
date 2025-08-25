//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  MTLineDashArray.swift
//  MapTilerSDK
//

import Foundation

/// Represents a dash array for line styling, either as raw pattern string or numeric array.
public enum MTLineDashArray: Sendable, Codable {
    case pattern(String)
    case values([Double])

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .pattern(let s):
            try container.encode(s)
        case .values(let arr):
            try container.encode(arr)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let s = try? container.decode(String.self) {
            self = .pattern(s)
            return
        }
        if let arr = try? container.decode([Double].self) {
            self = .values(arr)
            return
        }
        throw DecodingError.typeMismatch(MTLineDashArray.self, .init(codingPath: decoder.codingPath, debugDescription: "Unsupported type for MTLineDashArray"))
    }
}

