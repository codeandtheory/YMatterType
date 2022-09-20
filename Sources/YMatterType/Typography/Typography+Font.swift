//
//  Typography+Font.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

extension Typography {
    /// Generates the font and auxilliary layout information needed to render the Typography
    ///
    /// `maximumPointSize` will have no effect for fixed Typographies (`isFixed` = `true`).
    /// - Parameters:
    ///   - maximumPointSize: (optional) maximum point size for Dynamic Type, default = nil, means no maximum
    ///   - traitCollection: trait collection to apply (looking for preferredContentSizeCategory and legibilityWeight)
    /// - Returns: Font and various styles used to render the Typography
    public func generateLayout(
        maximumPointSize: CGFloat? = nil,
        compatibleWith traitCollection: UITraitCollection?
    ) -> TypographyLayout {
        var font = generateFixedFont(compatibleWith: traitCollection)

        var scaledLineHeight = lineHeight

        if !isFixed {
            let metrics = UIFontMetrics(forTextStyle: textStyle)

            if let maximumPointSize = maximumPointSize {
                font = metrics.scaledFont(
                    for: font,
                    maximumPointSize: maximumPointSize,
                    compatibleWith: traitCollection
                )
                if font.pointSize < maximumPointSize {
                    scaledLineHeight = metrics.scaledValue(for: lineHeight, compatibleWith: traitCollection)
                } else {
                    // scaledValue(:) will return too large a value in this case, so we calculate based on the
                    // ratio of the returned pointSize and the original fontSize
                    scaledLineHeight = (font.pointSize / fontSize) * lineHeight
                }
            } else {
                font = metrics.scaledFont(
                    for: font,
                    compatibleWith: traitCollection
                )
                scaledLineHeight = metrics.scaledValue(for: lineHeight, compatibleWith: traitCollection)
            }
        }

        // We need to adjust the baseline so that the text will appear vertically centered
        // (while still retaining enough room for descenders below the baseline and accents
        // above the main bounding box)
        //
        // swiftlint:disable line_length
        // See Figure 8-4 here: https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html
        // swiftlint:enable line_length

        // Our goal is to move the baseline upwards enough that the bounding rectangle
        // (whose height = capHeight) is centered within the line height,
        // but we don't go below zero because that would clip any descenders (e.g. lowercase g, j, or y).
        // We go ahead and round the amount up to the nearest pixel (slightly favoring room
        // for descenders which are more common than accents)

        // Note: by my math the offset should only be divided by 2 not 4,
        // but testing indicates that increasing baseline offset by 1 moves the text up 2 points,
        // hence we divide by 2 again.
        let scale = UIScreen.main.scale
        let baselineOffset = max(
            ceil(((scaledLineHeight - (abs(font.descender) + font.leading) * 2 - font.capHeight) / 4) * scale) / scale,
            0
        )
        return TypographyLayout(
            font: font,
            lineHeight: scaledLineHeight,
            baselineOffset: baselineOffset,
            kerning: letterSpacing,
            paragraphIndent: paragraphIndent,
            paragraphSpacing: paragraphSpacing,
            textCase: textCase,
            textDecoration: textDecoration
        )
    }

    /// Generates the font and auxilliary layout information needed to render the Typography
    ///
    /// `maximumScaleFactor` will have no effect for fixed Typographies (`isFixed` = `true`).
    /// - Parameters:
    ///   - maximumScaleFactor: (optional) maximum scale factor for Dynamic Type,
    ///   e.g. `2.0` for a 16 pt font would mean limit maximum point size to 32 pts.
    ///   - traitCollection: trait collection to apply (looking for preferredContentSizeCategory and legibilityWeight)
    /// - Returns: Font and various styles used to render the Typography
    public func generateLayout(
        maximumScaleFactor: CGFloat,
        compatibleWith traitCollection: UITraitCollection?
    ) -> TypographyLayout {
        generateLayout(maximumPointSize: maximumScaleFactor * fontSize, compatibleWith: traitCollection)
    }

    /// Generates the font and auxilliary layout information needed to render the Typography
    ///
    /// Internal method for use by UI components such as `TypographyLabel` and `TypographyButton`.
    /// At most one of `maximumScaleFactor` and `maximumPointSize` should be set.
    /// If both parameters are non-nil, then `maximumScaleFactor` will be used.
    ///
    /// Neither `maximumScaleFactor` nor `maximumPointSize` will have any effect for fixed Typographies
    /// (`isFixed` = `true`).
    /// - Parameters:
    ///   - maximumScaleFactor: maximum scale factor for Dynamic Type, nil means no maximum scale factor.
    ///   e.g. `2.0` for a 16 pt font would mean limit maximum point size to 32 pts.
    ///   - maximumPointSize: (optional) maximum point size for Dynamic Type, nil means no maximum point size.
    ///   - traitCollection: trait collection to apply (looking for preferredContentSizeCategory and legibilityWeight)
    /// - Returns: Font and various styles used to render the Typography
    internal func generateLayout(
        maximumScaleFactor: CGFloat?,
        maximumPointSize: CGFloat?,
        compatibleWith traitCollection: UITraitCollection?
    ) -> TypographyLayout {
        if let maximumScaleFactor = maximumScaleFactor {
            return generateLayout(maximumPointSize: maximumScaleFactor * fontSize, compatibleWith: traitCollection)
        }

        return generateLayout(maximumPointSize: maximumPointSize, compatibleWith: traitCollection)
    }
}

private extension Typography {
    func generateFixedFont(compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        fontFamily.font(for: fontWeight, pointSize: fontSize, compatibleWith: traitCollection)
    }
}
