//
//  HelveticaNeueFontFamilyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/2/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class HelveticaNeueFontFamilyTests: XCTestCase {
    func testFont() {
        let (families, traitCollections) = makeSUT()
        for family in families {
            for weight in family.supportedWeights {
                for traitCollection in traitCollections {
                    let pointSize = CGFloat(Int.random(in: 10...32))
                    let font = family.font(for: weight, pointSize: pointSize, compatibleWith: traitCollection)
                    XCTAssertEqual(font.familyName, "Helvetica Neue")
                    XCTAssertEqual(font.pointSize, pointSize)
                }
            }
        }
    }

    func testRegular() {
        let (families, _) = makeSUT()
        for family in families {
            XCTAssertTrue(family.weightName(for: .regular).isEmpty)
        }
    }

    func testUnsupportedWeights() {
        let (families, _) = makeSUT()
        for family in families {
            let unsupported = Typography.FontWeight.allCases.filter { !family.supportedWeights.contains($0) }
            for weight in unsupported {
                XCTAssertTrue(family.weightName(for: weight).isEmpty)
            }
        }
    }
}

private extension HelveticaNeueFontFamilyTests {
    func makeSUT() -> ([FontFamily], [UITraitCollection?]) {
        let families: [FontFamily] = [Typography.helveticaNeue, Typography.helveticaNeueItalic]
        let traitCollections: [UITraitCollection?] = [
            nil,
            UITraitCollection(legibilityWeight: .unspecified),
            UITraitCollection(legibilityWeight: .regular),
            UITraitCollection(legibilityWeight: .bold)
        ]
        return (families, traitCollections)
    }
}
