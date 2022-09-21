//
//  TypographyLayout.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/27/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// Typography layout comprises a font and additional typographical information (line height, kerning, etc.).
/// This information is used to render the actual typography using attributed strings.
/// A layout is the output of `Typography.generateLayout(...)`
public struct TypographyLayout {
    /// Font to use (potentially scaled and considering Accessibility Bold Text)
    public let font: UIFont
    
    /// Scaled line height to use with this font
    public let lineHeight: CGFloat

    /// Baseline offset to use with this font (to vertically center the text within the line height)
    public let baselineOffset: CGFloat

    /// Kerning to apply for letter spacing with this font
    public let kerning: CGFloat

    /// Paragraph indent to apply
    public let paragraphIndent: CGFloat

    /// Paragraph spacing to apply
    public let paragraphSpacing: CGFloat
    
    /// Text case to apply to text
    public let textCase: Typography.TextCase

    /// Text decoration to apply
    public let textDecoration: Typography.TextDecoration

    /// Paragraph style with the correct line height for rendering multi-line text
    public let paragraphStyle: NSParagraphStyle

    /// Line height multiple to use with this font (to achieve the desired line height)
    public var lineHeightMultiple: CGFloat { lineHeight / font.lineHeight }

    init(
        font: UIFont,
        lineHeight: CGFloat,
        baselineOffset: CGFloat,
        kerning: CGFloat,
        paragraphIndent: CGFloat,
        paragraphSpacing: CGFloat,
        textCase: Typography.TextCase,
        textDecoration: Typography.TextDecoration
    ) {
        self.font = font
        self.lineHeight = lineHeight
        self.baselineOffset = baselineOffset
        self.kerning = kerning
        self.paragraphIndent = paragraphIndent
        self.paragraphSpacing = paragraphSpacing
        self.textCase = textCase
        self.textDecoration = textDecoration
        self.paragraphStyle = NSParagraphStyle.default.styleWithLineHeight(
            lineHeight,
            indent: paragraphIndent,
            spacing: paragraphSpacing
        )
    }
}

public extension TypographyLayout {
    /// Whether the text needs to styled as an attributed string to display properly.
    ///
    /// If `false` plain text can be set instead.
    var needsStylingForSingleLine: Bool {
        kerning != 0 || textCase != .none || textDecoration != .none
    }

    /// Style plain text using this layout
    /// - Parameters:
    ///   - text: the text to style
    ///   - isSingleLine: `true` for single line text, `false` for potentially multi-line text.
    ///    Paragraph styles will not be applied to single line text.
    ///   - additionalAttributes: any additional attributes to apply
    ///   (e.g. `UITextView` requires `.foregroundColor`), default = `[:]`
    /// - Returns: an attributed string containing the styled text.
    func styleText(
        _ text: String,
        lineMode: Typography.LineMode,
        additionalAttributes: [NSAttributedString.Key: Any] = [:]
    ) -> NSAttributedString {
        let attributes = buildAttributes(startingWith: additionalAttributes, lineMode: lineMode)
        return NSAttributedString(
            string: text.textCase(textCase),
            attributes: attributes
        )
    }

    /// Style attributed text using this layout
    /// - Parameters:
    ///   - text: the text to style
    ///   - isSingleLine: `true` for single line text, `false` for potentially multi-line text.
    ///    Paragraph styles will not be applied to single line text.
    ///   - additionalAttributes: any additional attributes to apply
    ///   (e.g. `UITextView` requires `.foregroundColor`), default = `[:]`
    /// - Returns: an attributed string containing the styled text.
    func styleAttributedText(
        _ attributedText: NSAttributedString,
        lineMode: Typography.LineMode,
        additionalAttributes: [NSAttributedString.Key: Any] = [:]
    ) -> NSAttributedString {
        let attributes = buildAttributes(startingWith: additionalAttributes, lineMode: lineMode)
        return attributedText.textCase(textCase).attributedString(with: attributes)
    }
}

private extension TypographyLayout {
    func buildAttributes(
        startingWith additionalAttributes: [NSAttributedString.Key: Any],
        lineMode: Typography.LineMode
    ) -> [NSAttributedString.Key: Any] {
        var attributes = additionalAttributes
        if case let .multi(textAlignment, lineBreakMode) = lineMode {
            let style = NSMutableParagraphStyle()
            style.setParagraphStyle(paragraphStyle)
            style.alignment = textAlignment
            if let lineBreakMode = lineBreakMode {
                style.lineBreakMode = lineBreakMode
            }
            attributes[.paragraphStyle] = style
            attributes[.baselineOffset] = baselineOffset
        }

        attributes[.font] = font

        // Only apply kerning if it is non-zero
        if kerning != 0 {
            attributes[.kern] = kerning
        }

        // Apply text decoration (if any)
        switch textDecoration {
        case .none:
            break
        case .underline:
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        case .strikethrough:
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        return attributes
    }
}
