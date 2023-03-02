//
//  HelveticaNeueFontFamily.swift
//  YMatterType
//
//  Created by Mark Pospesel on 3/2/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

public extension Typography {
    /// HelveticaNeue font family
    static let helveticaNeue = HelveticaNeueFontFamily(style: .regular)
    /// HelveticaNeue Italic font family
    static let helveticaNeueItalic = HelveticaNeueFontFamily(style: .italic)
}

/// Information about the Helvetica Neue family of fonts
public struct HelveticaNeueFontFamily: FontFamily {
    /// Font family root name
    public let familyName: String = "HelveticaNeue"

    /// Font style, e.g. regular or italic
    public let style: Typography.FontStyle

    /// Initialize a `HelveticaNeueFontFamily` object
    /// - Parameter style: font style (default = `.regular`)
    public init(style: Typography.FontStyle = .regular) {
        self.style = style
    }

    /// HelveticaNeue supports 6 font weights (nothing heavier than bold)
    public var supportedWeights: [Typography.FontWeight] {
        [.ultralight, .thin, .light, .regular, .medium, .bold]
    }

    public func weightName(for weight: Typography.FontWeight) -> String {
        // Default font name suffix by weight
        switch weight {
        case .ultralight:
            return "UltraLight"
        case .thin:
            return "Thin"
        case .light:
            return "Light"
        case .regular:
            return "" // HelveticaNeue skips the weight name for regular
        case .medium:
            return "Medium"
        case .bold:
            return "Bold"
        case .semibold, .heavy, .black:
            return "" // HelveticaNeue does not support these weights
        }
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
