//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  SetSky.swift
//  MapTilerSDK
//

import Foundation

/// Sets the value of style's sky properties.
package struct SetSky: MTCommand {
    var sky: MTSkySpecification
    var options: MTStyleSetterOptions?

    package func toJS() -> JSString {
        let skyString: JSString = sky.toJSON() ?? "{}"
        let parameters: JSString = options != nil ? "\(skyString),\(options.toJSON() ?? "")" : skyString

        return "\(MTBridge.mapObject).setSky(\(parameters));"
    }
}
