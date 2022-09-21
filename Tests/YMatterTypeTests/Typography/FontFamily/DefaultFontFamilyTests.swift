//
//  DefaultFontFamilyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 9/21/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class DefaultFontFamilyTests: XCTestCase {
    func testFontNameSuffix() {
        // Given
        let sut = DefaultFontFamily(familyName: "Mock", style: .regular)
        let sutItalic = DefaultFontFamily(familyName: "Mock", style: .italic)

        // Then
        XCTAssertEqual(sut.fontNameSuffix, "")
        XCTAssertEqual(sutItalic.fontNameSuffix, "Italic")
    }
}
