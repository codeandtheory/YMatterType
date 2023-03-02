//
//  DefaultFontFamilyFactoryTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 9/21/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class DefaultFontFamilyFactoryTests: XCTestCase {
    func testGetFontFamily() {
        // Given
        let sut = DefaultFontFamilyFactory()

        // When
        let regular = sut.getFontFamily(familyName: "Foo", style: .regular)
        let italic = sut.getFontFamily(familyName: "Bar", style: .italic)
        let helveticaNeue = sut.getFontFamily(familyName: "HelveticaNeue", style: .regular)

        // Then
        XCTAssertTrue(regular is DefaultFontFamily)
        XCTAssertEqual(regular.familyName, "Foo")
        XCTAssertEqual(regular.fontNameSuffix, "")
        XCTAssertTrue(italic is DefaultFontFamily)
        XCTAssertEqual(italic.familyName, "Bar")
        XCTAssertEqual(italic.fontNameSuffix, "Italic")
        XCTAssertEqual(helveticaNeue.familyName, "HelveticaNeue")
        XCTAssertEqual(helveticaNeue.weightName(for: .regular), "")
    }
}
