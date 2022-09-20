//
//  TypographyTextViewTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 12/17/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyTextViewTests: TypographyElementTests {
    override func setUp() async throws {
        try await super.setUp()
        try UIFont.register(name: "SF-Pro-Display-Semibold")
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try UIFont.unregister(name: "SF-Pro-Display-Semibold")
    }

    func testInitWithCoder() throws {
        let sut = TypographyTextView(coder: try makeCoder(for: makeSUT()))
        XCTAssertNil(sut)
    }

    func testSingleLine() {
        let sut = makeSUT()
        // Given a text view with a single line of text
        sut.text = "Hello World"

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the correct family
        XCTAssertEqual(
            sut.font?.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to equal lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
        // after calling sizeToFit we expect bounds to equal intrinsicContentSize
        sut.sizeToFit()
        XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
    }

    func testMultiLine() {
        [2, 3, 5, 8, 13].forEach {
            // Given a text view with text that spans multiple lines
            let spacing = CGFloat(Int.random(in: 1..<10))
            let sut = makeSUT(spacing: spacing)
            let array: [String] = Array(repeating: "Hello World", count: $0)
            sut.text = array.joined(separator: "\n")

            // we expect label height to be a multiple of lineHeight + paragraph spacing
            XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * CGFloat($0) + spacing * CGFloat($0 - 1))
            // after calling sizeToFit we expect bounds to equal intrinsicContentSize
            sut.sizeToFit()
            XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
        }
    }

    func testSetAlignment() {
        let sut = makeSUT()
        // Given a text view with 2 lines of text
        sut.text = "Hello World\nHello World"

        let alignments: [NSTextAlignment] = [.natural, .left, .right, .center, .justified]

        alignments.forEach {
            // if we change its alignment
            sut.clear()
            sut.textAlignment = $0

            // its font should not be adjusted (only its paragraph style)
            XCTAssertFalse(sut.isFontAdjusted)
            // for right, center, justified we expect paragraph style to reflect accordingly
            XCTAssertEqual(sut.paragraphStyle.alignment, $0)

            // we still expect label height to be a multiple of lineHeight
            XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)
        }
    }

    func testSetTypography() {
        let sut = makeSUT()
        // Given a text view with 2 lines of text
        sut.text = "Hello World\nHello World"

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the old family
        XCTAssertEqual(
            sut.font?.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to be a multiple of the old lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)

        let fontInfo = FontInfo(familyName: "Verdana")
        let typography = Typography(
            fontFamily: fontInfo,
            fontWeight: .bold,
            fontSize: 18,
            lineHeight: 28,
            isFixed: true
        )

        // If we change its typography
        sut.clear()
        sut.typography = typography

        // its font should be adjusted, but not color or breakpoint
        XCTAssert(sut.isFontAdjusted)
        XCTAssertFalse(sut.isColorAdjusted)
        XCTAssertFalse(sut.isBreakpointAdjusted)

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the new family
        XCTAssertEqual(sut.font?.familyName, typography.fontFamily.familyName)
        // we expect label height to be a multiple of the new lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, typography.lineHeight * 2)
    }

    func testMaximumPointSize() {
        let sut = makeSUT()
        let fontInfo = FontInfo(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontInfo,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 18,
            isFixed: false
        )

        // Given a text view with 2 lines of text
        sut.typography = scaledType
        sut.text = "Hello World\nHello World"

        // create some nested view controllers so that we can override traits
        let (parent, child) = makeNestedViewControllers(subview: sut)

        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge) // really large
        parent.setOverrideTraitCollection(traits, forChild: child)

        let maximumPointSizes: [CGFloat] = [20, 24, 28, 32, 36]

        // Given a maximum point size at largest Dynamic Type Size
        maximumPointSizes.forEach {
            sut.clear()
            sut.maximumPointSize = $0
            // its font should be adjusted, but not color or breakpoint
            XCTAssert(sut.isFontAdjusted)
            XCTAssertFalse(sut.isColorAdjusted)
            XCTAssertFalse(sut.isBreakpointAdjusted)

            // point size should equal the maximum
            XCTAssertEqual(sut.font?.pointSize, $0)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by the ratio of the maximumPointSize / original point size (16)
            XCTAssertEqual(sut.intrinsicContentSize.height, $0 / scaledType.fontSize * scaledType.lineHeight * 2)
        }
    }

    func testMaximumScaleFactor() {
        let sut = makeSUT()
        let fontInfo = FontInfo(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontInfo,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 18,
            isFixed: false
        )

        // Given a text view with 2 lines of text
        sut.typography = scaledType
        sut.text = "Hello World\nHello World"

        // create some nested view controllers so that we can override traits
        let (parent, child) = makeNestedViewControllers(subview: sut)

        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge) // really large
        parent.setOverrideTraitCollection(traits, forChild: child)

        let maximumScaleFactors: [CGFloat] = [1.25, 1.5, 1.75, 2, 2.25]

        // Given a maximum point size at largest Dynamic Type Size
        maximumScaleFactors.forEach {
            sut.clear()
            sut.maximumScaleFactor = $0
            sut.maximumPointSize = 25 // this will be ignored in favor of scale factor
            // its font should be adjusted, but not color or breakpoint
            XCTAssert(sut.isFontAdjusted)
            XCTAssertFalse(sut.isColorAdjusted)
            XCTAssertFalse(sut.isBreakpointAdjusted)

            // point size should equal the original fontSize x maximumScaleFactor
            XCTAssertEqual(sut.font?.pointSize, $0 * scaledType.fontSize)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by maximum scale factor
            XCTAssertEqual(sut.intrinsicContentSize.height, $0 * scaledType.lineHeight * 2)
        }
    }

    func testSetText() {
        let sut = makeSUT()
        // Given a text view with 2 lines of text
        sut.text = "Hello World\nHello World"

        // we expect text to not be nil or empty
        XCTAssertFalse(sut.text?.isEmpty ?? true)
        XCTAssertFalse(sut.attributedText?.string.isEmpty ?? true)

        // but if we clear it
        sut.text = nil

        // we expect it to be nil or empty
        XCTAssert(sut.text?.isEmpty ?? true)
        XCTAssert(sut.attributedText?.string.isEmpty ?? true)
    }

    func testAttributedText() {
        let sut = makeSUT()
        // First set the text view to have two lines of non-attributed text
        sut.text = "A\nB"
        sut.layoutIfNeeded()
        // we expect text view height to equal twice the lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)

        // Given a text view with a single line of attributed text
        sut.attributedText = NSAttributedString(
            string: "Hello World",
            attributes: [.strikethroughStyle: 1]
            )

        // we expect text to not be nil or empty
        XCTAssertFalse(sut.text?.isEmpty ?? true)
        XCTAssertFalse(sut.attributedText?.string.isEmpty ?? true)

        // changing the text alignment will restyle the attributed text
        sut.textAlignment = .center
        XCTAssertFalse(sut.attributedText?.string.isEmpty ?? true)
        // we expect the style to still have strikethrough
        XCTAssertTrue(sut.attributedText?.hasUniversalAttribute(key: .strikethroughStyle) ?? false)
        // we expect text view height to equal the lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        // then if we clear it
        sut.attributedText = nil

        // we expect it to be nil or empty
        XCTAssert(sut.text?.isEmpty ?? true)
        XCTAssert(sut.attributedText?.string.isEmpty ?? true)
    }

    func testTextCase() {
        let sut = makeSUT()
        sut.text = "First name"

        // we don't expect text case by default
        XCTAssertEqual(sut.typography.textCase, .none)
        XCTAssertEqual(sut.text, "First name")

        // setting a text case should transform the text
        sut.typography = sut.typography.textCase(.lowercase)
        XCTAssertEqual(sut.text, "first name")

        sut.typography = sut.typography.textCase(.uppercase)
        XCTAssertEqual(sut.text, "FIRST NAME")

        sut.typography = sut.typography.textCase(.capitalize)
        XCTAssertEqual(sut.text, "First Name")

        // setting text should apply the text case
        sut.text = "john"
        XCTAssertEqual(sut.text, "John")
        
        // setting attributed text should also apply the text case
        sut.attributedText = NSAttributedString(string: "first name", attributes: [.underlineStyle: 1])
        XCTAssertEqual(sut.attributedText?.string, "First Name")
    }
}

private extension TypographyTextViewTests {
    func makeSUT(spacing: CGFloat = 0, file: StaticString = #filePath, line: UInt = #line) -> MockTextView {
        let typography = Typography(
            fontFamily: Typography.sfProDisplay,
            fontWeight: .semibold,
            fontSize: 22,
            lineHeight: 28,
            paragraphSpacing: spacing,
            textStyle: .title2,
            isFixed: true
        )
        let sut = MockTextView(typography: typography)
        sut.isScrollEnabled = false
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
