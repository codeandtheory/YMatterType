//
//  Typography+YMatterTypeTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 12/8/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import YMatterType

extension Typography {
    /// SF Pro Display, Semibold 32/36 pts
    static let largeTitle = Typography(
        fontFamily: Typography.sfProDisplay,
        fontWeight: .semibold,
        fontSize: 32,
        lineHeight: 36,
        textStyle: .largeTitle
    )

    /// SF Pro Display, Semibold 28/34 pts
    static let title1 = Typography(
        fontFamily: Typography.sfProDisplay,
        fontWeight: .semibold,
        fontSize: 28,
        lineHeight: 34,
        textStyle: .title1
    )

    /// SF Pro Display, Semibold 22/28 pts
    static let title2 = Typography(
        fontFamily: Typography.sfProDisplay,
        fontWeight: .semibold,
        fontSize: 22,
        lineHeight: 28,
        textStyle: .title2
    )

    /// SF Pro Text, Semibold 17/22 pts (underlined)
    static let headline = Typography(
        fontFamily: Typography.sfProText,
        fontWeight: .semibold,
        fontSize: 17,
        lineHeight: 22,
        letterSpacing: 0.2,
        textDecoration: .underline,
        textStyle: .headline
    )

    /// SF Pro Text, Regular 16/22 pts
    static let subhead = Typography(
        fontFamily: Typography.sfProText,
        fontWeight: .regular,
        fontSize: 16,
        lineHeight: 22,
        letterSpacing: 0.4,
        textCase: .uppercase,
        textStyle: .subheadline
    )

    /// SF Pro Text, Regular 15/20 pts
    static let body = Typography(
        fontFamily: Typography.sfProText,
        fontWeight: .regular,
        fontSize: 15,
        lineHeight: 20,
        paragraphIndent: 8,
        paragraphSpacing: 10,
        textStyle: .body
    )

    /// SF Pro Text, Regular 14/20 pts
    static let smallBody = Typography(
        fontFamily: Typography.sfProText,
        fontWeight: .regular,
        fontSize: 14,
        lineHeight: 20,
        paragraphIndent: 8,
        paragraphSpacing: 8,
        textStyle: .callout
    )

    /// SF Pro Text, Bold 15/20 pts
    static let bodyBold = Typography.body.bold

    /// SF Pro Text, Bold 14/20 pts
    static let smallBodyBold = Typography.smallBody.bold
}
