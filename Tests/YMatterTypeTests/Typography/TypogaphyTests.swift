//
//  TypogaphyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/24/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypogaphyTests: XCTestCase {
    func testInit() {
        // test the default initializer
        let avenir = DefaultFontFamily(familyName: "AvenirNext")
        let typeInfo = Typography(fontFamily: avenir, fontWeight: .bold, fontSize: 16, lineHeight: 24)
        
        XCTAssertNotNil(typeInfo.generateLayout(compatibleWith: .default))
        _testDefaults(typeInfo)
    }

    func testInit2() {
        // test the convenience initializer
        let typeInfo = Typography(familyName: "AvenirNext", fontWeight: .bold, fontSize: 16, lineHeight: 24)
        
        XCTAssertNotNil(typeInfo.generateLayout(compatibleWith: .default))
        _testDefaults(typeInfo)
    }

    private func _testDefaults(_ typography: Typography) {
        // Confirm default init parameter values
        XCTAssertEqual(typography.letterSpacing, 0)
        XCTAssertEqual(typography.textStyle, UIFont.TextStyle.body)
        XCTAssertFalse(typography.isFixed)
    }
}
