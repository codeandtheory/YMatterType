//
//  TypographyLayoutTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/27/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyLayoutTests: XCTestCase {
    func testLineHeightMultiple() {
        let sut = makeSUT()
        XCTAssertEqual(sut.lineHeightMultiple * sut.font.lineHeight, 20)
    }

    func testParagraphStyle() {
        let sut = makeSUT()
        XCTAssertEqual(sut.paragraphStyle.minimumLineHeight, sut.lineHeight)
        XCTAssertEqual(sut.paragraphStyle.maximumLineHeight, sut.lineHeight)
    }

    func testBaselineOffset() {
        let sut = makeSUT()
        // baselineOffset should be >= 0
        XCTAssertGreaterThanOrEqual(sut.baselineOffset, 0)
        // and it should be ceiled to 1/scale (pixel precision)
        XCTAssertEqual(sut.baselineOffset.ceiled(), sut.baselineOffset)
    }

    func testKerning() {
        let (text, attributedText) = makeText()

        [-1.6, 0, 2.4].forEach {
            let sut = makeSUT(letterSpacing: $0)
            XCTAssertEqual(sut.kerning, $0)

            _testKernAttribute(styled: sut.styleText(text, lineMode: .single), letterSpacing: $0)
            _testKernAttribute(styled: sut.styleAttributedText(attributedText, lineMode: .single), letterSpacing: $0)
        }
    }

    func testTextCase() {
        Typography.TextCase.allCases.forEach {
            let sut = makeSUT(textCase: $0)
            XCTAssertEqual(sut.textCase, $0)
        }
    }

    func testTextDecoration() {
        let (text, attributedText) = makeText()

        Typography.TextDecoration.allCases.forEach {
            let sut = makeSUT(textDecoration: $0)
            XCTAssertEqual(sut.textDecoration, $0)

            _testDecorationAttributes(styled: sut.styleText(text, lineMode: .single), textDecoration: $0)

            _testDecorationAttributes(
                styled: sut.styleAttributedText(attributedText, lineMode: .single),
                textDecoration: $0
            )
        }
    }

    func testNeedsStylingForSingleLine() {
        for kerning in [-1.6, 0, 2.4] {
            for textCase in Typography.TextCase.allCases {
                for textDecoration in Typography.TextDecoration.allCases {
                    let sut = makeSUT(letterSpacing: kerning, textCase: textCase, textDecoration: textDecoration)
                    XCTAssertEqual(
                        sut.needsStylingForSingleLine,
                        kerning != 0 || textCase != .none || textDecoration != .none
                    )
                }
            }
        }
    }

    func testStyleText() {
        let sut = makeSUT()
        let (text, _) = makeText()

        // given text styled as single line
        var styled = sut.styleText(text, lineMode: .single)
        // we expect it to not have paragraph style
        XCTAssertNil(styled.attribute(.paragraphStyle, at: 0, effectiveRange: nil))

        // but given text styled as multi line
        styled = sut.styleText(text, lineMode: .multi(alignment: .natural, lineBreakMode: .byWordWrapping))
        // we expect it to have paragraph style
        XCTAssertNotNil(styled.attribute(.paragraphStyle, at: 0, effectiveRange: nil))
    }

    func testStyleAttributedText() {
        let sut = makeSUT()
        let (_, attributedText) = makeText()

        // given attributed text styled as single line
        var styled = sut.styleAttributedText(attributedText, lineMode: .single)
        // we expect it to not have paragraph style
        XCTAssertNil(styled.attribute(.paragraphStyle, at: 0, effectiveRange: nil))

        // but given attributed text styled as multi line
        styled = sut.styleAttributedText(
            attributedText,
            lineMode: .multi(alignment: .natural, lineBreakMode: .byWordWrapping)
        )
        // we expect it to have paragraph style
        XCTAssertNotNil(styled.attribute(.paragraphStyle, at: 0, effectiveRange: nil))
    }
}

private extension TypographyLayoutTests {
    func makeSUT(
        letterSpacing: CGFloat = 0,
        textCase: Typography.TextCase = .none,
        textDecoration: Typography.TextDecoration = .none
    ) -> TypographyLayout {
        let fontFamily = DefaultFontFamily(familyName: "Futura")

        let typography = Typography(
            fontFamily: fontFamily,
            fontWeight: .medium,
            fontSize: 16,
            lineHeight: 20,
            letterSpacing: letterSpacing,
            textCase: textCase,
            textDecoration: textDecoration
        )

        return typography.generateLayout(compatibleWith: .default)
    }

    func makeText() -> (String, NSAttributedString) {
        let text = "Hello World"
        let attributedText = NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.label])
        return (text, attributedText)
    }

    func _testKernAttribute(styled: NSAttributedString, letterSpacing: Double) {
        let kernValue = styled.attribute(.kern, at: 0, effectiveRange: nil) as? Double
        if letterSpacing == 0 {
            // should not have the kern style
            XCTAssertNil(kernValue)
        } else {
            // should have the correct kern value
            XCTAssertEqual(kernValue, letterSpacing)
        }
    }

    func _testDecorationAttributes(styled: NSAttributedString, textDecoration: Typography.TextDecoration) {
        let underlineValue = styled.attribute(.underlineStyle, at: 0, effectiveRange: nil) as? Int
        let strikethroughValue = styled.attribute(.strikethroughStyle, at: 0, effectiveRange: nil) as? Int
        
        switch textDecoration {
        case .none:
            XCTAssertNil(strikethroughValue)
            XCTAssertNil(underlineValue)
        case .strikethrough:
            XCTAssertEqual(strikethroughValue, NSUnderlineStyle.single.rawValue)
            XCTAssertNil(underlineValue)
        case .underline:
            XCTAssertNil(strikethroughValue)
            XCTAssertEqual(underlineValue, NSUnderlineStyle.single.rawValue)
        }
    }
}
