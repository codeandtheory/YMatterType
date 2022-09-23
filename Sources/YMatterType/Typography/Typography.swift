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
    public let fontFamily: FontFamily
    /// Font weight
    public let fontWeight: FontWeight
    /// Font size (aka point size)
    public let fontSize: CGFloat
    /// Line height (typically greater than font size)
    public let lineHeight: CGFloat
    /// Letter spacing (in points, not percentage)
    public let letterSpacing: CGFloat
    /// Paragraph indent (in points)
    public let paragraphIndent: CGFloat
    /// Paragraph spacing (in points)
    public let paragraphSpacing: CGFloat
    /// Text case
    public let textCase: TextCase
    /// Text decoration (none, underline, or strikethrough)
    public let textDecoration: TextDecoration
    /// The text style (e.g. Body or Title) that this font most closely represents.
    /// Used for Dynamic Type scaling of the font
    public let textStyle: UIFont.TextStyle
    /// Whether this font is fixed in size or should be scaled through Dynamic Type
    public let isFixed: Bool

    /// The factory to use to convert from family name + font style into a `FontFamily`.
    /// The default is to use `DefaultFontFamilyFactory`.
    ///
    /// If you use a custom font family (or families) in your project, create your own factory to
    /// return the correct font family and then set it here, preferably as early as possible in the
    /// app launch lifecycle.
    public static var factory: FontFamilyFactory = DefaultFontFamilyFactory()

    /// Initializes a typography instance with the specified parameters
    /// - Parameters:
    ///   - fontFamily: font family to use
    ///   - fontWeight: font weight to use
    ///   - fontSize: font size to use
    ///   - lineHeight: line height to use
    ///   - chaacterSpacing: letter spacing to use (defaults to `0`)
    ///   - paragraphIndent: paragraph indent to use (defaults to `0`)
    ///   - paragraphSpacing: paragraph spacing to use (defaults to `0`)
    ///   - textCase: text case to apply (defaults to `.none`)
    ///   - textDecoration: text decoration to apply (defaults to `.none`)
    ///   - textStyle: text style to use for scaling (defaults to `.body`)
    ///   - isFixed: `true` if this font should never scale, `false` if it should scale (defaults to `.false`)
    public init(
        fontFamily: FontFamily,
        fontWeight: FontWeight,
        fontSize: CGFloat,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0,
        paragraphIndent: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
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
        self.paragraphIndent = paragraphIndent
        self.paragraphSpacing = paragraphSpacing
        self.textCase = textCase
        self.textDecoration = textDecoration
        self.textStyle = textStyle
        self.isFixed = isFixed
    }
    
    /// Initializes a typography instance with the specified parameters
    /// - Parameters:
    ///   - familyName: font family name
    ///   - fontStyle: font style (defaults to `regular`)
    ///   - fontWeight: font weight to use
    ///   - fontSize: font size to use
    ///   - lineHeight: line height to use
    ///   - chaacterSpacing: letter spacing to use (defaults to `0`)
    ///   - paragraphIndent: paragraph indent to use (defaults to `0`)
    ///   - paragraphSpacing: paragraph spacing to use (defaults to `0`)
    ///   - textCase: text case to apply (defaults to `.none`)
    ///   - textDecoration: text decoration to apply (defaults to `.none`)
    ///   - textStyle: text style to use for scaling (defaults to `.body`)
    ///   - isFixed: `true` if this font should never scale, `false` if it should scale (defaults to `.false`)
    public init(
        familyName: String,
        fontStyle: FontStyle = .regular,
        fontWeight: FontWeight,
        fontSize: CGFloat,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0,
        paragraphIndent: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        textCase: TextCase = .none,
        textDecoration: TextDecoration = .none,
        textStyle: UIFont.TextStyle = .body,
        isFixed: Bool = false
    ) {
        self.init(
            fontFamily: Self.factory.getFontFamily(familyName: familyName, style: fontStyle),
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            paragraphIndent: paragraphIndent,
            paragraphSpacing: paragraphSpacing,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }
}
