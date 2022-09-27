//
//  Typography+SystemTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/25/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographySystemTests: XCTestCase {
    func testSystemLabel() {
        let sut = Typography.systemLabel
        XCTAssertEqual(sut.fontSize, Typography.labelFontSize)
        XCTAssertEqual(sut.fontWeight, Typography.labelFontWeight)
        _testLineHeight(sut: sut)
    }

    func testSystemButton() {
        let sut = Typography.systemButton
        XCTAssertEqual(sut.fontSize, Typography.buttonFontSize)
        XCTAssertEqual(sut.fontWeight, Typography.buttonFontWeight)
        _testLineHeight(sut: sut)
    }

#if !os(tvOS)
    func testSystem() {
        let sut = Typography.system
        XCTAssertEqual(sut.fontSize, UIFont.systemFontSize)
        XCTAssertEqual(sut.fontWeight, .regular)
        _testLineHeight(sut: sut)
    }

    func testSmallSystem() {
        let sut = Typography.smallSystem
        XCTAssertEqual(sut.fontSize, UIFont.smallSystemFontSize)
        XCTAssertEqual(sut.fontWeight, .regular)
        _testLineHeight(sut: sut)
    }
#endif

    private func _testLineHeight(sut: Typography) {
        XCTAssertEqual(sut.lineHeight, ceil(sut.fontSize * Typography.systemLineHeightMultiple))
    }
}
