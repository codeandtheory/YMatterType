//
//  Typography+MutatorsTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 12/8/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyMutatorsTests: XCTestCase {
    private let types: [Typography] = {
        var styles: [Typography] = [
            .title1,
            .title2,
            .headline,
            .subhead,
            .body,
            .bodyBold,
            .smallBody,
            .smallBodyBold
        ]
#if !os(tvOS)
        styles.insert(.largeTitle, at: 0)
#endif
        return styles
    }()

    func testFamilyName() {
        types.forEach {
            let familyName = "AppleSDGothicNeo"
            let typography = $0.familyName(familyName)
            _test(original: $0, modified: typography, familyName: familyName)
           let layout = typography.generateLayout(compatibleWith: UITraitCollection(legibilityWeight: .regular))
            XCTAssertEqual(layout.font.familyName.removeSpaces(), familyName)
        }
    }
    
    func testRegular() {
        types.forEach {
            _test(original: $0, modified: $0.regular, weight: .regular)
        }
    }

    func testBold() {
        types.forEach {
            _test(original: $0, modified: $0.bold, weight: .bold)
        }
    }
    
    func testFontWeight() {
        types.forEach {
            for fontweight in Typography.FontWeight.allCases {
                _test(original: $0, modified: $0.fontWeight(fontweight), weight: fontweight)
            }
        }
    }
    
    func testFontSize() {
        types.forEach {
            let newFontSize = $0.fontSize + 1
            _test(original: $0, modified: $0.fontSize(newFontSize), fontSize: newFontSize)
        }
    }
    
    func testLineHeight() {
        types.forEach {
            let newLineHeight = $0.lineHeight + 2
            _test(original: $0, modified: $0.lineHeight(newLineHeight), lineHeight: newLineHeight)
        }
    }

    func testFixed() {
        types.forEach {
            _test(original: $0, modified: $0.fixed, isFixed: true)
        }
    }

    func testLetterSpacing() {
        types.forEach {
            for kerning in [-1.5, 0, 0.8] {
                _test(original: $0, modified: $0.letterSpacing(kerning), letterSpacing: kerning)
            }
        }
    }

    func testTextCase() {
        types.forEach {
            for textCase in Typography.TextCase.allCases {
                _test(original: $0, modified: $0.textCase(textCase), textCase: textCase)
            }
        }
    }

    func testTextDecoration() {
        types.forEach {
            for textDecoration in Typography.TextDecoration.allCases {
                _test(original: $0, modified: $0.decoration(textDecoration), textDecoration: textDecoration)
            }
        }
    }

    private func _test(
        original: Typography,
        modified: Typography,
        familyName: String? = nil,
        weight: Typography.FontWeight? = nil,
        fontSize: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        isFixed: Bool? = nil,
        letterSpacing: CGFloat? = nil,
        textCase: Typography.TextCase? = nil,
        textDecoration: Typography.TextDecoration? = nil
    ) {
        let familyName = familyName ?? original.fontFamily.familyName
        let weight = weight ?? original.fontWeight
        let fontSize = fontSize ?? original.fontSize
        let lineHeight = lineHeight ?? original.lineHeight
        let isFixed = isFixed ?? original.isFixed
        let kerning = letterSpacing ?? original.letterSpacing
        let textCase = textCase ?? original.textCase
        let textDecoration = textDecoration ?? original.textDecoration

        // familyName, fontWeight, fontSize, lineHeight, isFixed,
        // letterSpacing, textCase, and textDecoration should be as expected
        XCTAssertEqual(modified.fontFamily.familyName, familyName)
        XCTAssertEqual(modified.fontWeight, weight)
        XCTAssertEqual(modified.fontSize, fontSize)
        XCTAssertEqual(modified.lineHeight, lineHeight)
        XCTAssertEqual(modified.isFixed, isFixed)
        XCTAssertEqual(modified.letterSpacing, kerning)
        XCTAssertEqual(modified.textCase, textCase)
        XCTAssertEqual(modified.textDecoration, textDecoration)

        // the other variables should be the same
        XCTAssertEqual(modified.textStyle, original.textStyle)
        XCTAssertEqual(modified.paragraphIndent, original.paragraphIndent)
        XCTAssertEqual(modified.paragraphSpacing, original.paragraphSpacing)
    }
}
