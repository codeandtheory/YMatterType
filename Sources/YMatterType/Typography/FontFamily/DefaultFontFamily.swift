//
//  DefaultFontFamily.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// Information about a font family. Default implementation of FontFamily.
public struct DefaultFontFamily: FontFamily {
    /// Suffix to use for italic family font names "Italic"
    public static let italicSuffix = "Italic"

    /// Font family root name, e.g. "AvenirNext"
    public let familyName: String

    /// Font style, e.g. regular or italic
    public let style: Typography.FontStyle

    /// Initialize a `DefaultFontFamily` object
    /// - Parameters:
    ///   - familyName: font family name
    ///   - style: font style (default = `.regular`)
    public init(familyName: String, style: Typography.FontStyle = .regular) {
        self.familyName = familyName
        self.style = style
    }

    /// Optional suffix to use for the font name.
    ///
    /// Used by `FontFamily.fontName(for:compatibleWith:)`
    /// e.g. "Italic" is a typical suffix for italic fonts.
    /// default = ""
    public var fontNameSuffix: String {
        (style == .italic) ? DefaultFontFamily.italicSuffix : ""
    }
}

/// Information about a font family. Default implementation of FontFamily.
///
/// Renamed to `DefaultFontFamily`
@available(*, deprecated, renamed: "DefaultFontFamily")
public typealias FontInfo = DefaultFontFamily
