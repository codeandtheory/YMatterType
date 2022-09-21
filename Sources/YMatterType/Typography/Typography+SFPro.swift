//
//  Typography+SFPro.swift
//  YMatterType
//
//  Created by Mark Pospesel on 10/7/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import Foundation

/// Typographical information about Apple's SF family of fonts
public struct SFProFontFamily: FontFamily {
    fileprivate enum SFProFamily {
        case display
        case displayItalic
        case text
        case textItalic
    }
    
    private let family: SFProFamily
    
    /// Font family root name, e.g. "SFProText" or "SFProDisplay"
    public var familyName: String {
        switch family {
        case .display, .displayItalic: return "SFProDisplay"
        case .text, .textItalic: return "SFProText"
        }
    }
    
    /// Font style, e.g. regular or italic
    public var style: Typography.FontStyle {
        let style: Typography.FontStyle
        switch family {
        case .display, .text:
            style = .regular
        case .displayItalic, .textItalic:
            style = .italic
        }
        return style
    }
    
    fileprivate init(family: SFProFamily) {
        self.family = family
    }
    
    /// Generates a weight name suffix as part of a full font name. Not all fonts support all 9 weights.
    /// - Parameter weight: desired font weight
    /// - Returns: The weight name to use
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
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "SemiBold"
        case .bold:
            return "Bold"
        case .heavy:
            return "Heavy"
        case .black:
            return "Black"
        }
    }
    
    /// Optional suffix to use for the font name.
    ///
    /// Used by `FontFamily.fontName(for:compatibleWith:)`
    /// e.g. "Italic" is a typical suffix for italic fonts.
    /// default = ""
    public var fontNameSuffix: String {
        (style == .italic) ? FontInfo.italicSuffix : ""
    }
}

extension Typography {
    /// Typographical information for SF Pro Display font
    public static let sfProDisplay = SFProFontFamily(family: .display)
    /// Typographical information for SF Pro Display Italic font
    public static let sfProDisplayItalic = SFProFontFamily(family: .displayItalic)
    /// Typographical information for SF Pro Text font
    public static let sfProText = SFProFontFamily(family: .text)
    /// Typographical information for SF Pro Text Italic font
    public static let sfProTextItalic = SFProFontFamily(family: .textItalic)
}
