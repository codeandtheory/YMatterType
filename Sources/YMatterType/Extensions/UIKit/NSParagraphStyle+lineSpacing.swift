//
//  NSParagraphStyle+lineSpacing.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

extension NSParagraphStyle {
    /// Combines line spacing with the existing style
    /// - Parameter lineSpacing: the line spacing to use
    /// - Returns: Current paragraph style combined with line spacing
    public func styleWithLineSpacing(_ lineSpacing: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = (mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
    /// Combines line height multiple with the existing style
    /// - Parameter lineHeightMultiple: the line height multiple to use
    /// - Returns: Current paragraph style combined with line height multiple
    public func styleWithLineHeightMultiple(_ lineHeightMultiple: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = (mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        return paragraphStyle
    }
    
    /// Combines text alignment with the existing style
    /// - Parameter alignment: the text alignment to use
    /// - Returns: Current paragraph style combined with text alignment
    public func styleWithAlignment(_ alignment: NSTextAlignment) -> NSParagraphStyle {
        let paragraphStyle = (mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return paragraphStyle
    }

    /// Combines line height with the existing style
    /// - Parameter lineHeight: the line height to use
    /// - Returns: Current paragraph style combined with minimumLineHeight and maximumLineHeight both set to lineHeight

    /// Combines line height with the existing style
    /// - Parameters:
    ///   - lineHeight: the line height to use
    ///   - indent: the indent to use (ignored if `0`)
    ///   - spacing: the spacing to use (ignored if `0`)
    /// - Returns: Current paragraph style combined with line height and (if non-zero) indent and spacing
    public func styleWithLineHeight(
        _ lineHeight: CGFloat,
        indent: CGFloat = 0,
        spacing: CGFloat = 0
    ) -> NSParagraphStyle {
        let paragraphStyle = (mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        if indent != 0 {
            paragraphStyle.firstLineHeadIndent = indent
        }
        if spacing != 0 {
            paragraphStyle.paragraphSpacing = spacing
        }
        return paragraphStyle
    }
}
