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
        let typeInfo = Typography(fontFamily: avenir, fontWeight: .regular, fontSize: 16, lineHeight: 24)
        let layout = typeInfo.generateLayout(compatibleWith: .default)

        XCTAssertEqual(layout.font.familyName, "Avenir Next")
        _testDefaults(typeInfo)
    }

    func testInit2() {
        // test the convenience initializer
        let typeInfo = Typography(familyName: "AvenirNext", fontWeight: .regular, fontSize: 16, lineHeight: 24)
        let layout = typeInfo.generateLayout(compatibleWith: .default)

        XCTAssertEqual(layout.font.familyName, "Avenir Next")
        _testDefaults(typeInfo)
    }

    func testFactory() throws {
        // Given
        Typography.factory = NotoSansFactory()
        try UIFont.register(name: "NotoSans-Regular")
        addTeardownBlock {
            Typography.factory = DefaultFontFamilyFactory()
            try UIFont.unregister(name: "NotoSans-Regular")
        }

        // When
        let typeInfo = Typography(familyName: "AvenirNext", fontWeight: .regular, fontSize: 16, lineHeight: 24)
        let layout = typeInfo.generateLayout(compatibleWith: .default)

        // Then
        XCTAssertEqual(layout.font.familyName, "Noto Sans")
    }

    private func _testDefaults(_ typography: Typography) {
        // Confirm default init parameter values
        XCTAssertEqual(typography.letterSpacing, 0)
        XCTAssertEqual(typography.textStyle, UIFont.TextStyle.body)
        XCTAssertNil(typography.maximumScaleFactor)
        XCTAssertFalse(typography.isFixed)
    }
}

struct NotoSansFontFamily: FontFamily {
    let familyName = "NotoSans"

    var supportedWeights: [Typography.FontWeight] { [.regular] }
}

struct AvenirNextFontFamily: FontFamily {
    let familyName = "AvenirNext"

    var supportedWeights: [Typography.FontWeight] { [.ultralight, .regular, .medium, .semibold, .bold, .heavy] }

    func weightName(for weight: Typography.FontWeight) -> String {
        switch weight {
        case .ultralight:
            return "UltraLight"
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "DemiBold"
        case .bold:
            return "Bold"
        case .heavy:
            return "Heavy"
        case .thin, .light, .black:
            return "" // these 3 weights are not installed
        }
    }
}

extension Typography {
    static let notoSans = NotoSansFontFamily()
}

struct NotoSansFactory: FontFamilyFactory {
    // Always returns Noto Sans font family
    func getFontFamily(familyName: String, style: YMatterType.Typography.FontStyle) -> YMatterType.FontFamily {
        Typography.notoSans
    }
}
