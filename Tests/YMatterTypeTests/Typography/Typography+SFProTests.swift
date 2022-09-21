//
//  Typography+SFProTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 10/7/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographySFProTests: XCTestCase {
    private let boldTraits = UITraitCollection(legibilityWeight: .bold)

    override func setUp() async throws {
        try await super.setUp()
        try makeFontNames().forEach {
            try UIFont.register(name: $0)
        }
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try makeFontNames().forEach {
            try UIFont.unregister(name: $0)
        }
    }
    
    func testSFProDisplay() {
        _testFontFamily(Typography.sfProDisplay, style: .regular)
    }

    func testSFProDisplayItalic() {
        _testFontFamily(Typography.sfProDisplayItalic, style: .italic)
    }

    func testSFProText() {
        _testFontFamily(Typography.sfProText, style: .regular)
    }
    
    func testSFProTextItalic() {
        _testFontFamily(Typography.sfProTextItalic, style: .italic)
    }
}

private extension TypographySFProTests {
    func _testFontFamily(_ fontFamily: FontFamily, style: Typography.FontStyle) {
        Typography.FontWeight.allCases.forEach {
            let typography = Typography(
                fontFamily: fontFamily,
                fontWeight: $0,
                fontSize: 14,
                lineHeight: 20,
                textStyle: .callout
            )
            
            _testTypography(typography, style: style, traits: nil)
            _testTypography(typography, style: style, traits: boldTraits)
        }
    }
    
    func _testTypography(_ typography: Typography, style: Typography.FontStyle, traits: UITraitCollection?) {
        let layout = typography.generateLayout(compatibleWith: traits)
        
        // we expect a font
        XCTAssertNotNil(layout.font)
        
        // we expect the font to have the correct family
        XCTAssertEqual(
            layout.font.familyName.removeSpaces(),
            typography.fontFamily.familyName.removeSpaces()
            )

        // we expect the font to be italic or not
        let fontName = layout.font.fontName
        if style == .italic {
            XCTAssertTrue(fontName.hasSuffix(FontInfo.italicSuffix))
        } else {
            XCTAssertFalse(fontName.hasSuffix(FontInfo.italicSuffix))
        }
    }

    func makeFontNames() -> [String] {
        [
            "SF-Pro-Display-Black",
            "SF-Pro-Display-BlackItalic",
            "SF-Pro-Display-Bold",
            "SF-Pro-Display-BoldItalic",
            "SF-Pro-Display-Heavy",
            "SF-Pro-Display-HeavyItalic",
            "SF-Pro-Display-Light",
            "SF-Pro-Display-LightItalic",
            "SF-Pro-Display-Medium",
            "SF-Pro-Display-MediumItalic",
            "SF-Pro-Display-Regular",
            "SF-Pro-Display-RegularItalic",
            "SF-Pro-Display-Semibold",
            "SF-Pro-Display-SemiboldItalic",
            "SF-Pro-Display-Thin",
            "SF-Pro-Display-ThinItalic",
            "SF-Pro-Display-Ultralight",
            "SF-Pro-Display-UltralightItalic",
            "SF-Pro-Text-Black",
            "SF-Pro-Text-BlackItalic",
            "SF-Pro-Text-Bold",
            "SF-Pro-Text-BoldItalic",
            "SF-Pro-Text-Heavy",
            "SF-Pro-Text-HeavyItalic",
            "SF-Pro-Text-Light",
            "SF-Pro-Text-LightItalic",
            "SF-Pro-Text-Medium",
            "SF-Pro-Text-MediumItalic",
            "SF-Pro-Text-Regular",
            "SF-Pro-Text-RegularItalic",
            "SF-Pro-Text-Semibold",
            "SF-Pro-Text-SemiboldItalic",
            "SF-Pro-Text-Thin",
            "SF-Pro-Text-ThinItalic",
            "SF-Pro-Text-Ultralight",
            "SF-Pro-Text-UltralightItalic"
        ]
    }
}

extension String {
    func removeSpaces() -> String {
        replacingOccurrences(of: " ", with: "")
    }
}
