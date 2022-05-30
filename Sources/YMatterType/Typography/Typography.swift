//
//  Typography.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// Represents a font as it would appear in a design document
public struct Typography {
    /// Information about the font family
    public let fontFamily: FontRepresentable
    /// Font weight
    public let fontWeight: FontWeight
    /// Font size (aka point size)
    public let fontSize: CGFloat
    /// Line height (typically greater than font size)
    public let lineHeight: CGFloat
    /// Letter spacing (in points, not percentage)
    public let letterSpacing: CGFloat
    /// Text case
    public let textCase: TextCase
    /// Text decoration (none, underline, or strikethrough)
    public let textDecoration: TextDecoration
    /// The text style (e.g. Body or Title) that this font most closely represents.
    /// Used for Dynamic Type scaling of the font
    public let textStyle: UIFont.TextStyle
    /// Whether this font is fixed in size or should be scaled through Dynamic Type
    public let isFixed: Bool
    
    /// Initializes a typography instance with the specified parameters
    /// - Parameters:
    ///   - fontFamily: font family to use
    ///   - fontWeight: font weight to use
    ///   - fontSize: font size to use
    ///   - lineHeight: line height to use
    ///   - chaacterSpacing: letter spacing to use (defaults to `0`)
    ///   - textCase: text case to apply (defaults to `.none`)
    ///   - textDecoration: text decoration to apply (defaults to `.none`)
    ///   - textStyle: text style to use for scaling (defaults to `.body`)
    ///   - isFixed: `true` if this font should never scale, `false` if it should scale (defaults to `.false`)
    public init(
        fontFamily: FontRepresentable,
        fontWeight: FontWeight,
        fontSize: CGFloat,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0,
        textCase: TextCase = .none,
        textDecoration: TextDecoration = .none,
        textStyle: UIFont.TextStyle = .body,
        isFixed: Bool = false
    ) {
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.textCase = textCase
        self.textDecoration = textDecoration
        self.textStyle = textStyle
        self.isFixed = isFixed
    }
    
    /// Initializes a typography instance with the specified parameters
    /// - Parameters:
    ///   - familyName: font family name
    ///   - isItalic: whether this font is italic or not (defaults to `.false`)
    ///   - fontWeight: font weight to use
    ///   - fontSize: font size to use
    ///   - lineHeight: line height to use
    ///   - chaacterSpacing: letter spacing to use (defaults to `0`)
    ///   - textCase: text case to apply (defaults to `.none`)
    ///   - textDecoration: text decoration to apply (defaults to `.none`)
    ///   - textStyle: text style to use for scaling (defaults to `.body`)
    ///   - isFixed: `true` if this font should never scale, `false` if it should scale (defaults to `.false`)
    public init(
        familyName: String,
        isItalic: Bool = false,
        fontWeight: FontWeight,
        fontSize: CGFloat,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0,
        textCase: TextCase = .none,
        textDecoration: TextDecoration = .none,
        textStyle: UIFont.TextStyle = .body,
        isFixed: Bool = false
    ) {
        self.init(
            fontFamily: FontInfo(familyName: familyName, isItalic: isItalic),
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }
}
