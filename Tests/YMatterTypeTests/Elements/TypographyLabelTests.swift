//
//  TypographyLabelTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/26/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

// It's not a problem having too many tests!
// swiftlint:disable file_length
// swiftlint:disable type_body_length

final class TypographyLabelTests: TypographyElementTests {
    override func setUp() async throws {
        try await super.setUp()
        try UIFont.register(name: "NotoSans-Regular")
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try UIFont.unregister(name: "NotoSans-Regular")
    }

    func testInitWithCoder() throws {
        let sut = TypographyLabel(coder: try makeCoder(for: makeSUT()))
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
        // Given a label with a single line of text
        sut.text = "Hello World"
        sut.numberOfLines = 1
        
        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the correct family
        XCTAssertEqual(
            sut.font.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to equal lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
        // after calling sizeToFit we expect bounds to equal intrinsicContentSize
        sut.sizeToFit()
        XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
    }

    func testMultiLine() {
        let spacing = CGFloat(Int.random(in: 1..<10))
        let sut = makeSUT(spacing: spacing)
        sut.numberOfLines = 0
        
        // Given a label with text that spans multiple lines
        [2, 3, 5, 8, 13].forEach {
            let array: [String] = Array(repeating: "Hello World", count: $0)
            sut.text = array.joined(separator: "\n")

            // we expect label height to be a multiple of lineHeight + paragraph spacing
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                sut.typography.lineHeight * CGFloat($0) + spacing * CGFloat($0 - 1)
            )
            // after calling sizeToFit we expect bounds to equal intrinsicContentSize
            sut.sizeToFit()
            XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
        }
    }
    
    func testSetAlignment() {
        let sut = makeSUT()
        // Given a label with 2 lines of text
        sut.numberOfLines = 0
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
    
    func testSetLineBreak() {
        let sut = makeSUT()
        // Given a label with 2 lines of text
        sut.numberOfLines = 0
        sut.text = "Hello World\nHello World"
        
        let lineBreaks: [NSLineBreakMode] = [
            .byWordWrapping,
            .byCharWrapping,
            .byClipping,
            .byTruncatingHead,
            .byTruncatingTail,
            .byTruncatingMiddle
        ]
        
        lineBreaks.forEach {
            // if we change its line break mode
            sut.clear()
            sut.lineBreakMode = $0
            
            // its font should not be adjusted (only its paragraph style)
            XCTAssertFalse(sut.isFontAdjusted)
            // we expect paragraph style to reflect accordingly
            XCTAssertEqual(sut.paragraphStyle.lineBreakMode, $0)

            // we still expect label height to be a multiple of lineHeight
            XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)
        }
    }
    
    func testSetTypography() {
        let sut = makeSUT()
        // Given a label with 2 lines of text
        sut.numberOfLines = 0
        sut.text = "Hello World\nHello World"

        // we expect a font
        XCTAssertNotNil(sut.font)
        // we expect the font to have the old family
        XCTAssertEqual(
            sut.font.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to be a multiple of the old lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)

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
        XCTAssertEqual(sut.font.familyName.removeSpaces(), typography.fontFamily.familyName)
        // we expect label height to be a multiple of the new lineHeight
        XCTAssertEqual(sut.intrinsicContentSize.height, typography.lineHeight * 2)
    }
    
#if os(iOS)
    func testMaximumPointSize() {
        let sut = makeSUT()
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontFamily,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 18,
            isFixed: false
        )

        // Given a label with 2 lines of text
        sut.typography = scaledType
        sut.numberOfLines = 0
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
            XCTAssertEqual(sut.font.pointSize, $0)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by the ratio of the maximumPointSize / original point size (16)
            XCTAssertEqual(sut.intrinsicContentSize.height, $0 / scaledType.fontSize * scaledType.lineHeight * 2)
        }
    }

    func testMaximumScaleFactor() {
        let sut = makeSUT()
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontFamily,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 18,
            isFixed: false
        )

        // Given a label with 2 lines of text
        sut.typography = scaledType
        sut.numberOfLines = 0
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
            XCTAssertEqual(sut.font.pointSize, $0 * scaledType.fontSize)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by maximum scale factor
            XCTAssertEqual(sut.intrinsicContentSize.height, $0 * scaledType.lineHeight * 2)
        }
    }
#endif
    
    func testSetText() {
        let sut = makeSUT()
        // Given a label with 2 lines of text
        sut.numberOfLines = 0
        sut.text = "Hello World\nHello World"
        
        // we expect text to not be nil
        XCTAssertNotNil(sut.text)
        XCTAssertNotNil(sut.attributedText)
        
        // but if we clear it
        sut.text = nil
        
        // we expect it to be nil
        XCTAssertNil(sut.text)
        XCTAssertNil(sut.attributedText)
    }
    
    func testAttributedText() {
        let sut = makeSUT()
        // First set the label to have two lines of non-attributed text
        sut.numberOfLines = 0
        sut.text = "A\nB"
        sut.layoutIfNeeded()
        // we expect label height to equal twice the lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight * 2)

        // Given a label with a single line of attributed text
        sut.numberOfLines = 1
        sut.attributedText = NSAttributedString(
            string: "Hello World",
            attributes: [.strikethroughStyle: 1]
            )
        
        // we expect text to not be nil
        XCTAssertNotNil(sut.text)
        XCTAssertNotNil(sut.attributedText)
        
        // changing the text alignment will restyle the attributed text
        sut.textAlignment = .center
        XCTAssertNotNil(sut.attributedText)
        // we expect the style to still have strikethrough
        XCTAssertTrue(sut.attributedText?.hasUniversalAttribute(key: .strikethroughStyle) ?? false)
        // we expect label height to equal the lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)

        // then if we clear it
        sut.attributedText = nil
        
        // we expect it to be nil
        XCTAssertNil(sut.text)
        XCTAssertNil(sut.attributedText)
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

    func testParagraphIndent() {
        // Given
        let indent = CGFloat(Int.random(in: 1..<10))
        let sut = makeSUT()
        let sut2 = makeSUT(indent: indent)

        // When
        sut.text = "Hello World"
        sut2.text = "Hello World"

        // Then
        XCTAssertEqual(
            sut.intrinsicContentSize.width + indent,
            sut2.intrinsicContentSize.width
        )
    }
    
    func testFamilyName() {
        let sut = makeSUT()
        XCTAssertEqual(sut.familyName, "NotoSans")
        sut.familyName = "AppleSDGothicNeo"
        XCTAssertEqual(sut.familyName, "AppleSDGothicNeo")
    }
    
    func testFontWeight() {
        let sut = makeSUT()
        XCTAssertEqual(sut.fontWeight, 400)
        sut.fontWeight = 700
        XCTAssertEqual(sut.typography.fontWeight, .bold)
    }
    
    func testFontSize() {
        let sut = makeSUT()
        XCTAssertEqual(sut.fontSize, 24)
        sut.fontSize = 50
        XCTAssertEqual(sut.fontSize, 50)
    }
    
    func testLineHeight() {
        let sut = makeSUT()
        XCTAssertEqual(sut.lineHeight, 32)
        sut.lineHeight = 40
        XCTAssertEqual(sut.lineHeight, 40)
    }
    
    func testLetterSpacing() {
        let sut = makeSUT()
        XCTAssertEqual(sut.letterSpacing, 0)
        sut.letterSpacing = 5
        XCTAssertEqual(sut.letterSpacing, 5)
    }
}

private extension TypographyLabelTests {
    func makeSUT(
        indent: CGFloat = 0,
        spacing: CGFloat = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> MockLabel {
        let typography = Typography(
            familyName: "NotoSans",
            fontWeight: .regular,
            fontSize: 24,
            lineHeight: 32,
            paragraphIndent: indent,
            paragraphSpacing: spacing,
            isFixed: true
        )
        let sut = MockLabel(typography: typography)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
