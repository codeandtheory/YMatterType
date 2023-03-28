//
//  String+textSizeTests.swift
//  YMatterTypeTests
//
//  Created by Sahil Saini on 27/03/23.
//

import XCTest
@testable import YMatterType

final class StringTextSizeTests: XCTestCase {
    func test_sizeWithFont_deliversRoundedValues() {
        // Given
        let scale = CGFloat(Int.random(in: 1...3))
        let pointSize = CGFloat(Int.random(in: 10...24))
        let traits = UITraitCollection(displayScale: scale)
        let font = UIFont.systemFont(ofSize: pointSize, weight: .regular)
        let sut = "Hello"

        // When
        let size = sut.size(withFont: font, compatibleWith: traits)

        // Then
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
        XCTAssertEqual(size.width, ceil(size.width * scale) / scale)
        XCTAssertEqual(size.height, ceil(size.height * scale) / scale)
    }

    func test_sizeWithTypography_deliversRoundedValues() throws {
        // Given
        let scale = CGFloat(Int.random(in: 1...3))
        let traits = UITraitCollection(displayScale: scale)
        let typography = try XCTUnwrap(getTypographies().randomElement())
        let sut = "Hello"

        // When
        let size = sut.size(withTypography: typography, compatibleWith: traits)

        // Then
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
        XCTAssertEqual(size.width, ceil(size.width * scale) / scale)
        XCTAssertEqual(size.height, ceil(size.height * scale) / scale)
    }

    func test_sizeWithTypography_deliversLineHeight() {
        // Given
        let typography = Typography(
            fontFamily: Typography.systemFamily,
            fontWeight: .bold,
            fontSize: 24,
            lineHeight: 32,
            textStyle: .title1
        )
        let sut = "testString"

        // When
        let size = sut.size(withTypography: typography, compatibleWith: .default)

        // Then
        XCTAssertGreaterThan(size.height, 0)
        XCTAssertEqual(size.height, typography.lineHeight)
    }

    func test_sizeWithTypography_deliversScaledSize() throws {
        // Given
        let typography = try XCTUnwrap(getTypographies().randomElement())
        let sut = "testString"
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityMedium)

        // When
        let size = sut.size(withTypography: typography, compatibleWith: traits)

        // Then
        XCTAssertGreaterThan(size.height, typography.lineHeight)
    }

    func test_longerStrings_deliverGreaterWidths() {
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
        let sutSize1 = sut1.size(withTypography: typography, compatibleWith: .default)
        let sutSize2 = sut2.size(withTypography: typography, compatibleWith: .default)

        // Then
        XCTAssertGreaterThan(sutSize1.height, 0)
        XCTAssertGreaterThan(sutSize2.height, 0)
        XCTAssertGreaterThan(sutSize1.width, sutSize2.width)
        XCTAssertEqual(sutSize1.height, sutSize2.height)
    }

    func test_emptyString_deliversZeroWidth() {
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

extension StringTextSizeTests {
    func getTypographies() -> [Typography] {
        var typographies: [Typography] = [.systemButton, .systemLabel]
#if !os(tvOS)
        typographies.append(.system)
        typographies.append(.smallSystem)
#endif
        return typographies
    }
}
