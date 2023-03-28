//
//  String+textSizeTests.swift
//  YMatterTypeTests
//
//  Created by Sahil Saini on 27/03/23.
//

import XCTest
@testable import YMatterType

final class StringTextSizeTests: XCTestCase {
    func testHeightNotZero() {
        // Given
        let typography = Typography(
            fontFamily: Typography.systemFamily,
            fontWeight: .bold,
            fontSize: 24,
            lineHeight: 32,
            textStyle: .callout
        )
        let sut = "testString"
        // When
        let size = sut.size(withTypography: typography, compatibleWith: nil)
        // Then
        XCTAssertGreaterThan(size.height, 0)
        XCTAssertEqual(size.height, typography.lineHeight)
    }

    func testRelativeWidth() {
        // Given
        let typography = Typography(
            fontFamily: Typography.systemFamily,
            fontWeight: .bold,
            fontSize: 24,
            lineHeight: 32,
            textStyle: .body
        )
        let sut1 = "testString1"
        let sut2 = "testString"
        // When
        let sutSize1 = sut1.size(withTypography: typography, compatibleWith: UITraitCollection.default)
        let sutSize2 = sut2.size(withTypography: typography, compatibleWith: nil)
        // Then
        XCTAssertGreaterThan(sutSize1.height, 0)
        XCTAssertGreaterThan(sutSize2.height, 0)
        XCTAssertGreaterThan(sutSize1.width, sutSize2.width)
        XCTAssertEqual(sutSize1.height, sutSize2.height)
    }

    func testWidthIsZero() {
        // Given
        let typography = Typography(
            fontFamily: Typography.systemFamily,
            fontWeight: .bold,
            fontSize: 24,
            lineHeight: 32,
            textStyle: .caption1
        )
        let sut = ""
        // When
        let sutSize = sut.size(withTypography: typography, compatibleWith: nil)
        // Then
        XCTAssertGreaterThan(sutSize.height, 0)
        XCTAssertEqual(sutSize.width, 0)
    }
}
