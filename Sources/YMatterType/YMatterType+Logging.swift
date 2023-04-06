//
//  YMatterType+Logging.swift
//  YMatterType
//
//  Created by Sahil Saini on 04/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import os

/// Y—MatterType Settings
public struct YMatterType {
    /// Whether console logging for warnings is enabled. Defaults to `true`.
    public static var isLoggingEnabled = true
}

internal extension YMatterType {
    /// Logger for warnings related to font loading. cf. `FontFamily`
    static let fontLogger = Logger(subsystem: "YMatterType", category: "fonts")
}
