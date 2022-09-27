//
//  Typography+System.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

extension Typography {
    /// The multiple used to generate line heights from standard or system font sizes (130%)
    public static let systemLineHeightMultiple: CGFloat = 1.3

    /// Standard typography for labels (uses the system font)
    public static let systemLabel = makeSystemTypography(
        fontSize: labelFontSize, weight: labelFontWeight, textStyle: .body
    )

    /// Standard typography for buttons (uses the system font)
    public static let systemButton = makeSystemTypography(
        fontSize: buttonFontSize, weight: buttonFontWeight, textStyle: .subheadline
    )

    /// Typography for the system font
    @available(iOS 14, *)
    @available(tvOS, unavailable)
    public static let system = makeSystemTypography(
        fontSize: UIFont.systemFontSize, weight: .regular, textStyle: .callout
    )

    /// Typography for the small system font
    @available(iOS 14, *)
    @available(tvOS, unavailable)
    public static let smallSystem = makeSystemTypography(
        fontSize: UIFont.smallSystemFontSize, weight: .regular, textStyle: .footnote
    )

    private static func makeSystemTypography(
        fontSize: CGFloat,
        weight: Typography.FontWeight,
        textStyle: UIFont.TextStyle
    ) -> Typography {
        let lineHeight = ceil(fontSize * systemLineHeightMultiple)
        return Typography(
            fontFamily: Typography.systemFamily,
            fontWeight: weight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            textStyle: textStyle
        )
    }

#if os(tvOS)
    static var labelFontSize: CGFloat { 38.0 }
    static var labelFontWeight: FontWeight { .medium }
    static var buttonFontSize: CGFloat { 38.0 }
    static var buttonFontWeight: FontWeight { .medium }
#else
    static var labelFontSize: CGFloat { UIFont.labelFontSize }
    static var labelFontWeight: FontWeight { .regular }
    static var buttonFontSize: CGFloat { UIFont.buttonFontSize }
    static var buttonFontWeight: FontWeight { .regular }
#endif
}
