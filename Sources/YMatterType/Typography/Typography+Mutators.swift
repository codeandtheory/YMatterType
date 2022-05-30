//
//  Typography+Mutators.swift
//  YMatterType
//
//  Created by Mark Pospesel on 12/8/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

public extension Typography {
    /// Returns a copy of the Typography but with `.regular` font weight
    var regular: Typography {
        if fontWeight == .regular { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: .regular,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }

    /// Returns a copy of the Typography but with `.bold` font weight
    var bold: Typography {
        if fontWeight == .bold { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: .bold,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }

    /// Returns a copy of the Typography but with `isFixed` set to `true`
    var fixed: Typography {
        if isFixed { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: true
        )
    }

    /// Returns a copy of the Typography but with the new `letterSpacing` applied.
    /// - Parameter value: the letter spacing to use
    /// - Returns: an updated copy of the Typography
    func letterSpacing(_ value: CGFloat) -> Typography {
        if letterSpacing == value { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: value,
            textCase: textCase,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }

    /// Returns a copy of the Typography but with the new `textCase` applied.
    /// - Parameter value: the text case to use
    /// - Returns: an updated copy of the Typography
    func textCase(_ value: TextCase) -> Typography {
        if textCase == value { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: value,
            textDecoration: textDecoration,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }

    /// Returns a copy of the Typography but with the new `textDecoration` applied.
    /// - Parameter value: the text decoration to use
    /// - Returns: an updated copy of the Typography
    func decoration(_ value: TextDecoration) -> Typography {
        if textDecoration == value { return self }

        return Typography(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: value,
            textStyle: textStyle,
            isFixed: isFixed
        )
    }
}
