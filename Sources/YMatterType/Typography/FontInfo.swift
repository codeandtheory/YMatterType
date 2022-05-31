//
//  FontInfo.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// Information about a font family. Default implementation of FontRepresentable.
public struct FontInfo: FontRepresentable {
    /// Suffix to use for Italic family font names "Italic"
    public static let italicSuffix = "Italic"
    
    /// Font family root name, e.g. "AvenirNext"
    public let familyName: String
    
    /// Whether this is an Italic font
    public let isItalic: Bool
    
    /// Initialize a `FontInfo` object
    /// - Parameters:
    ///   - familyName: font family name
    ///   - isItalic: whether this font is Italic
    public init(familyName: String, isItalic: Bool = false) {
        self.familyName = familyName
        self.isItalic = isItalic
    }
    
    /// Optional suffix to use for Italic version of the font.
    /// Used by `FontRepresentable.fontName(for:compatibleWith:)`
    /// e.g. "Italic" is a typical suffix for Italic fonts.
    /// default = ""
    public var fontNameSuffix: String {
        isItalic ? FontInfo.italicSuffix : ""
    }
}
