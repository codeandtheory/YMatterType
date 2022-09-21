//
//  FontFamilyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/24/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class FontFamilyTests: XCTestCase {
    func testFontName() {
        let (sut, weightNames, traitCollection) = makeSUT()
        for weight in Typography.FontWeight.allCases {
            guard let weightName = weightNames[weight] else {
                XCTFail("No name associated with weight")
                continue
            }
            let expected = "\(sut.familyName)-\(weightName)"
            XCTAssertEqual(sut.fontName(for: weight, compatibleWith: traitCollection), expected)
        }
    }
    
    func testWeightName() {
        let (sut, weightNames, _) = makeSUT()
        Typography.FontWeight.allCases.forEach {
            let expected = weightNames[$0]
            XCTAssertNotNil(expected)
            XCTAssertEqual(sut.weightName(for: $0), expected)
        }
    }
    
    func testA11yBoldWeight() {
        let (sut, _, _) = makeSUT()
        Typography.FontWeight.allCases.forEach {
            let expectedWeight = min($0.rawValue + 100, 900)
            XCTAssertEqual(sut.accessibilityBoldWeight(for: $0).rawValue, expectedWeight)
        }
    }
    
    func testCompatibleTraitCollection() {
        let (sut, _, _) = makeSUT()
        let regular = "Regular"
        let bold = "Medium"
        
        let testCases: [(traits: UITraitCollection?, suffix: String)] = [
            (UITraitCollection(legibilityWeight: .regular), regular),
            (UITraitCollection(legibilityWeight: .unspecified), regular),
            (UITraitCollection(legibilityWeight: .bold), bold),
            (nil, UIAccessibility.isBoldTextEnabled ? bold : regular)
        ]
        
        testCases.forEach {
            XCTAssert(sut.fontName(for: .regular, compatibleWith: $0.traits).hasSuffix($0.suffix))
        }
    }

    func testFallback() {
        // This isn't a real font, so we expect it to fallback to the system font
        let (sut, _, _) = makeSUT()
        let font = sut.font(for: .regular, pointSize: 16, compatibleWith: .default)
        let systemFont = Typography.systemFamily.font(for: .regular, pointSize: 16, compatibleWith: .default)
        XCTAssertEqual(font.familyName, systemFont.familyName)
        XCTAssertEqual(font.fontName, systemFont.fontName)
        XCTAssertEqual(font.pointSize, systemFont.pointSize)
        XCTAssertEqual(font.lineHeight, systemFont.lineHeight)
    }

    func testIsBoldTextEnabled() {
        let (sut, _, _) = makeSUT()

        // given a traitCollection with legibilityWeight == .bold, it should return `true`
        XCTAssertTrue(sut.isBoldTextEnabled(compatibleWith: UITraitCollection(legibilityWeight: .bold)))
        XCTAssertTrue(sut.isBoldTextEnabled(compatibleWith: UITraitCollection(traitsFrom: [
            UITraitCollection(preferredContentSizeCategory: .extraLarge),
            UITraitCollection(legibilityWeight: .bold)
        ])))

        // given a traitCollection with legibilityWeight != .bold, it should return `false`
        XCTAssertFalse(sut.isBoldTextEnabled(compatibleWith: UITraitCollection(legibilityWeight: .regular)))
        XCTAssertFalse(sut.isBoldTextEnabled(compatibleWith: UITraitCollection(legibilityWeight: .unspecified)))

        // given a traitCollection without legibilityWeight trait, it should return `false`
        XCTAssertFalse(sut.isBoldTextEnabled(compatibleWith: UITraitCollection()))
        XCTAssertFalse(sut.isBoldTextEnabled(compatibleWith: UITraitCollection(preferredContentSizeCategory: .small)))

        // given traitCollection is nil, it should return the system setting
        XCTAssertEqual(sut.isBoldTextEnabled(compatibleWith: nil), UIAccessibility.isBoldTextEnabled)
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension FontFamilyTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (FontFamily, [Typography.FontWeight: String], UITraitCollection) {
        let sut = MockFontFamily()
        let weightNames: [Typography.FontWeight: String] = [
            .ultralight: "ExtraLight",
            .thin: "Thin",
            .light: "Light",
            .regular: "Regular",
            .medium: "Medium",
            .semibold: "SemiBold",
            .bold: "Bold",
            .heavy: "ExtraBold",
            .black: "Black"
        ]
        let traitCollection: UITraitCollection = .default

        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, weightNames, traitCollection)
    }
}

final class MockFontFamily: FontFamily {
    let familyName: String = "MockSerifMono"
}
