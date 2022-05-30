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
        XCTAssertEqual(sut.fontSize, UIFont.labelFontSize)
        _testLineHeight(sut: sut)
    }

    func testSystemButton() {
        let sut = Typography.systemButton
        XCTAssertEqual(sut.fontSize, UIFont.buttonFontSize)
        _testLineHeight(sut: sut)
    }

    func testSystem() {
        let sut = Typography.system
        XCTAssertEqual(sut.fontSize, UIFont.systemFontSize)
        _testLineHeight(sut: sut)
    }

    func testSmallSystem() {
        let sut = Typography.smallSystem
        _testLineHeight(sut: sut)
    }

    private func _testLineHeight(sut: Typography) {
        XCTAssertEqual(sut.lineHeight, ceil(sut.fontSize * Typography.systemLineHeightMultiple))
    }
}
