//
//  TypographyTextFieldTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 12/10/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyTextFieldTests: TypographyElementTests {
    override func setUp() async throws {
        try await super.setUp()
        try UIFont.register(name: "NotoSans-Regular")
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try UIFont.unregister(name: "NotoSans-Regular")
    }

    func testInitWithCoder() throws {
        let sut = TypographyTextField(coder: try makeCoder(for: makeSUT()))
        XCTAssertNotNil(sut)
#if os(tvOS)
        XCTAssertEqual(sut?.typography.fontSize, 38.0)
        XCTAssertEqual(sut?.typography.fontWeight, .medium)
        XCTAssertEqual(sut?.typography.textStyle, .body)
#else
        XCTAssertEqual(sut?.typography.fontSize, 17.0)
        XCTAssertEqual(sut?.typography.fontWeight, .regular)
        XCTAssertEqual(sut?.typography.textStyle, .body)
#endif
    }

    func testSingleLine() {
        let sut = makeSUT()
        // Given a text field with a single line of text
        sut.text = "Hello World"

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the correct family
        XCTAssertEqual(
            sut.font?.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect text field height to equal lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
    }

    func testNilText() {
        let sut = makeSUT()
        // Given a text field with no text
        sut.text = nil

        // we expect text field height to equal lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
    }

    func testEmptyText() {
        let sut = makeSUT()
        // Given a text field with empty text
        sut.text = ""

        // we expect text field height to equal lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
    }

    func testSetTypography() {
        let sut = makeSUT()
        // Given a text field
        sut.text = "Hello World"

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the old family
        XCTAssertEqual(
            sut.font?.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect text field height to equal the old lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        let fontFamily = DefaultFontFamily(familyName: "AvenirNext")
        let typography = Typography(
            fontFamily: fontFamily,
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
        XCTAssertEqual(sut.font?.familyName.removeSpaces(), typography.fontFamily.familyName)
        // we expect text field height to equal the new lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, typography.lineHeight)
    }

#if os(iOS)
    func testMaximumPointSize() {
        let sut = makeSUT()
        let scaledType = Typography.body

        // Given a text field
        sut.typography = scaledType
        sut.text = "Hello World"

        // create some nested view controllers so that we can override traits
        let (parent, child) = makeNestedViewControllers(subview: sut)

        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge) // really large
        parent.setOverrideTraitCollection(traits, forChild: child)

        let maximumPointSizes: [CGFloat] = [20, 24, 28, 30, 32, 36]

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
            // text fields's height should equal the line height
            // multiplied by the ratio of the maximumPointSize / original point size (16)
            XCTAssertEqual(sut.intrinsicContentSize.height, $0/scaledType.fontSize * scaledType.lineHeight)
        }
    }

    func testMaximumScaleFactor() {
        let sut = makeSUT()
        let scaledType = Typography.smallBody

        // Given a textField
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
            // text fields's height should equal the line height
            // multiplied by maximum scale factor
            XCTAssertEqual(sut.intrinsicContentSize.height, $0 * scaledType.lineHeight)
        }
    }
#endif
    
    func testSetText() {
        let sut = makeSUT()
        // Given a text field
        sut.text = "Hello World"

        // we expect text to not be empty
        XCTAssertFalse(sut.text.isEmpty)
        XCTAssertFalse((sut.attributedText?.string ?? "").isEmpty)

        // but if we clear it
        sut.text = nil

        // we expect it to be empty
        XCTAssertTrue(sut.text.isEmpty)
        XCTAssertTrue((sut.attributedText?.string ?? "").isEmpty)
    }

    func testAttributedText() {
        let sut = makeSUT()
        // Given a text field with attributed text
        sut.attributedText = NSAttributedString(
            string: "Hello World",
            attributes: [.strikethroughStyle: 1]
        )

        // we expect text to not be empty
        XCTAssertFalse(sut.text.isEmpty)
        XCTAssertFalse((sut.attributedText?.string ?? "").isEmpty)
        // we expect text field height to equal lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        // changing the typograhy will restyle the attributed text
        let fontFamily = DefaultFontFamily(familyName: "AvenirNext")
        sut.typography = Typography(
            fontFamily: fontFamily,
            fontWeight: .bold,
            fontSize: 18,
            lineHeight: 28,
            isFixed: true
        )

        XCTAssertNotNil(sut.attributedText)
        // we expect the style to still have strikethrough
        XCTAssertTrue(sut.attributedText?.hasUniversalAttribute(key: .strikethroughStyle) ?? false)
        // we expect text field height to equal lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        // then if we clear it
        sut.attributedText = nil

        // we expect it to be empty
        XCTAssertTrue(sut.text.isEmpty)
        XCTAssertTrue((sut.attributedText?.string ?? "").isEmpty)
    }

    func testTextInsets() {
        let sut = makeSUT()
#if os(iOS)
        // setting placeholder triggers a memory leak on tvOS (true for plain vanilla UITextField)!
        sut.placeholder = "First Name"
#endif
        sut.text = "John"

        // text insets should be zero by default
        XCTAssertEqual(sut.textInsets, TypographyTextField.defaultTextInsets)
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        // but if we apply different text insets, the height should adjust accordingly
        [-4.0, 0, 2.5, 16].forEach {
            let insets = UIEdgeInsets(
                top: $0,
                left: CGFloat(Int.random(in: -4...16)),
                bottom: $0,
                right: CGFloat(Int.random(in: -4...16))
            )
            sut.textInsets = insets
            XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight + insets.top + insets.bottom)

            let bounds = CGRect(x: 0, y: 0, width: 320, height: sut.typography.lineHeight + insets.top + insets.bottom)
            let insetBounds = bounds.inset(by: insets)
            XCTAssertEqual(sut.textRect(forBounds: bounds), insetBounds)
            XCTAssertEqual(sut.editingRect(forBounds: bounds), insetBounds)
            XCTAssertEqual(sut.leftViewRect(forBounds: bounds).minX, insetBounds.minX)
            XCTAssertEqual(sut.rightViewRect(forBounds: bounds).maxX, insetBounds.maxX)
            XCTAssertEqual(sut.clearButtonRect(forBounds: bounds).maxX, insetBounds.maxX - 5)
        }
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

private extension TypographyTextFieldTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> MockTextField {
        let typography = Typography(
            familyName: "NotoSans",
            fontWeight: .regular,
            fontSize: 13,
            lineHeight: 20,
            textStyle: .callout,
            isFixed: true
        )
        let sut = MockTextField(typography: typography)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
