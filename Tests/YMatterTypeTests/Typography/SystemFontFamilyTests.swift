//
//  SystemFontFamilyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 9/28/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class SystemFontFamilyTests: XCTestCase {
    func testFont() throws {
        let (sut, pointSizes, traitCollections) = makeSUT()
        let systemFont = UIFont.systemFont(ofSize: 12)
        
        for weight in Typography.FontWeight.allCases {
            for pointSize in pointSizes {
                for traitCollection in traitCollections {
                    let font = sut.font(for: weight, pointSize: pointSize, compatibleWith: traitCollection)
                    XCTAssertEqual(font.familyName, systemFont.familyName)
                    XCTAssertEqual(font.pointSize, pointSize)
                }
            }
        }
    }
    
    func testFamilyName() {
        let (sut, _, _) = makeSUT()
        XCTAssertTrue(sut.familyName.isEmpty)
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension SystemFontFamilyTests {
    func makeSUT() -> (FontFamily, [CGFloat], [UITraitCollection?]) {
        super.setUp()
        let sut = Typography.systemFamily
        let pointSizes: [CGFloat] = [10, 12, 14, 16, 18, 24, 28, 32]
        let traitCollections: [UITraitCollection?] = [
            nil,
            UITraitCollection(legibilityWeight: .unspecified),
            UITraitCollection(legibilityWeight: .regular),
            UITraitCollection(legibilityWeight: .bold)
        ]
        return (sut, pointSizes, traitCollections)
    }
}
