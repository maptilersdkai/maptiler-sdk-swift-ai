//
// Copyright (c) 2025, MapTiler
// All rights reserved.
// SPDX-License-Identifier: BSD 3-Clause
//
//  AddPolyline.swift
//  MapTilerSDK
//

import Foundation

package struct AddPolyline: MTCommand {
    var options: MTPolylineLayerOptions

    package func toJS() -> JSString {
        let json = options.toJSON() ?? "{}"
        return "\(MTBridge.sdkObject).helpers.addPolyline(\(MTBridge.mapObject), \(json));"
    }
}
