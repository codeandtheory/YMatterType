//
//  XCTestCase+TypographyEquatable.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/21/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

extension XCTestCase {
    /// Compares two typographies and asserts if they are not equal.
    ///
    /// `Typography` does not conform to `Equatable` because `fontFamily` is just a protocol
    /// that is itself not `Equatable`. We can however compare some properties of `FontFamily` as
    /// well as all the other properties of `Typography`.
    /// - Parameters:
    ///   - lhs: the first typography to compare
    ///   - rh2: the second typography to compare
    func XCTAssertTypographyEqual(_ lhs: Typography, _ rh2: Typography) {
        XCTAssertEqual(lhs.fontFamily.familyName, rh2.fontFamily.familyName)
        XCTAssertEqual(lhs.fontFamily.fontNameSuffix, rh2.fontFamily.fontNameSuffix)
        XCTAssertEqual(lhs.fontFamily.supportedWeights, rh2.fontFamily.supportedWeights)
        XCTAssertEqual(lhs.fontWeight, rh2.fontWeight)
        XCTAssertEqual(lhs.fontSize, rh2.fontSize)
        XCTAssertEqual(lhs.lineHeight, rh2.lineHeight)
        XCTAssertEqual(lhs.letterSpacing, rh2.letterSpacing)
        XCTAssertEqual(lhs.paragraphIndent, rh2.paragraphIndent)
        XCTAssertEqual(lhs.paragraphSpacing, rh2.paragraphSpacing)
        XCTAssertEqual(lhs.textDecoration, rh2.textDecoration)
        XCTAssertEqual(lhs.textStyle, rh2.textStyle)
        XCTAssertEqual(lhs.isFixed, rh2.isFixed)
    }
}
