//
//  TypographyButtonTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 9/27/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

// It's not a problem having too many tests!
// swiftlint:disable file_length
// swiftlint:disable type_body_length

final class TypographyButtonTests: TypographyElementTests {
    override func setUp() async throws {
        try await super.setUp()
        try UIFont.register(name: "SF-Pro-Text-Regular")
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try UIFont.unregister(name: "SF-Pro-Text-Regular")
    }

    func testInitWithCoder() throws {
        let sut = TypographyButton(coder: try makeCoder(for: makeSUT()))
        XCTAssertNil(sut)
    }

    func testSingleLine() {
        // Given a label with a single line of text
        let sut = makeSUT()
        sut.setTitle("Hello World", for: .normal)
        sut.titleLabel?.numberOfLines = 1
        
        // we expect a font
        XCTAssertNotNil(sut.titleLabel?.font)
        // we expect the font to have the correct family
        XCTAssertEqual(
            sut.titleLabel?.font.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to equal lineHeight
        XCTAssertEqual(
            sut.intrinsicContentSize.height,
            sut.typography.lineHeight + sut.contentEdgeInsets.vertical
        )
        // after calling sizeToFit we expect bounds to equal intrinsicContentSize
        sut.sizeToFit()
        XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
    }

    func testMultiLine() {
        let spacing = CGFloat(Int.random(in: 1..<10))
        let sut = makeSUT(spacing: spacing)
        sut.titleLabel?.numberOfLines = 0
        
        // Given a label with text that spans multiple lines
        [2, 3, 5, 8, 13].forEach {
            let array: [String] = Array(repeating: "Hello World", count: $0)
            sut.setTitle(array.joined(separator: "\n"), for: .normal)

            // we expect label height to be a multiple of lineHeight + paragraph spacing
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                sut.typography.lineHeight * CGFloat($0) + sut.contentEdgeInsets.vertical + spacing * CGFloat($0 - 1)
            )
            // after calling sizeToFit we expect bounds to equal intrinsicContentSize
            sut.sizeToFit()
            XCTAssertEqual(sut.intrinsicContentSize, sut.bounds.size)
        }
    }
    
    func testSetAlignment() {
        // Given a label with 2 lines of text
        let sut = makeSUT()
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)
        
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
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                sut.typography.lineHeight * 2 + sut.contentEdgeInsets.vertical
            )
        }
    }
    
    func testSetLineBreak() {
        // Given a label with 2 lines of text
        let sut = makeSUT()
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)
        
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
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                sut.typography.lineHeight * 2 + sut.contentEdgeInsets.vertical
            )
        }
    }
    
    func testSetTypography() {
        // Given a label with 2 lines of text
        let sut = makeSUT()
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)

        // we expect a font
        XCTAssertNotNil(sut.titleLabel?.font)
        // we expect the font to have the old family
        XCTAssertEqual(
            sut.titleLabel?.font.familyName.removeSpaces(),
            sut.typography.fontFamily.familyName.removeSpaces()
        )
        // we expect label height to be a multiple of the old lineHeight
        XCTAssertEqual(
            sut.intrinsicContentSize.height,
            sut.typography.lineHeight * 2 + sut.contentEdgeInsets.vertical
        )

        let fontFamily = DefaultFontFamily(familyName: "Verdana")
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

        sut.layoutIfNeeded()
        
        // we expect a font
        XCTAssertNotNil(sut.layout?.font)
        // we expect the font to have the new family
        XCTAssertEqual(sut.layout?.font.familyName, typography.fontFamily.familyName)
        // we expect label height to be a multiple of the new lineHeight
        XCTAssertEqual(
            sut.intrinsicContentSize.height,
            typography.lineHeight * 2 + sut.contentEdgeInsets.vertical
        )
    }

    func testMaximumPointSize() {
        let sut = makeSUT()
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontFamily,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 24,
            isFixed: false
        )

        // Given a label with 2 lines of text
        sut.typography = scaledType
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)

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
            sut.layoutIfNeeded()

            // point size should equal the maximum
            XCTAssertEqual(sut.layout?.font.pointSize, $0)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by the ratio of the maximumPointSize / original point size (16)
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                (($0/scaledType.fontSize) * scaledType.lineHeight * 2) + sut.contentEdgeInsets.vertical
            )
        }
    }

    func testMaximumScaleFactor() {
        let sut = makeSUT()
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let scaledType = Typography(
            fontFamily: fontFamily,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 24,
            isFixed: false
        )

        // Given a label with 2 lines of text
        sut.typography = scaledType
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)

        // create some nested view controllers so that we can override traits
        let (parent, child) = makeNestedViewControllers(subview: sut)

        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge) // really large
        parent.setOverrideTraitCollection(traits, forChild: child)

        let maximumScaleFactors: [CGFloat] = [1.25, 1.5, 1.75, 2, 2.25]

        // Given a maximum point size at largest Dynamic Type Size
        maximumScaleFactors.forEach {
            sut.clear()
            sut.maximumScaleFactor = $0
            sut.maximumPointSize = 23 // this will be ignored in favor of scale factor
            // its font should be adjusted, but not color or breakpoint
            XCTAssert(sut.isFontAdjusted)
            XCTAssertFalse(sut.isColorAdjusted)
            XCTAssertFalse(sut.isBreakpointAdjusted)
            sut.layoutIfNeeded()

            // point size should equal the original fontSize x maximumScaleFactor
            XCTAssertEqual(sut.layout?.font.pointSize, $0 * scaledType.fontSize)
            // label's height should be equal to the twice the lineHeight (2 lines of text)
            // multiplied by maximum scale factor
            XCTAssertEqual(
                sut.intrinsicContentSize.height,
                ($0 * scaledType.lineHeight * 2) + sut.contentEdgeInsets.vertical
            )
        }
    }

    func testSetText() {
        let sut = makeSUT()
        // Given a label with 2 lines of text
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("Hello World\nHello World", for: .normal)
        
        // we expect text to not be nil
        XCTAssertNotNil(sut.currentTitle)
        
        // but if we clear it
        sut.setTitle(nil, for: .normal)
        
        // we expect it to be nil
        XCTAssertNil(sut.currentTitle)
        XCTAssertNil(sut.currentAttributedTitle)
    }
    
    func testAttributedText() {
        let sut = makeSUT()
        // First set the button to have two lines of non-attributed text
        sut.titleLabel?.numberOfLines = 0
        sut.setTitle("A\nB", for: .normal)
        sut.layoutIfNeeded()
        // we expect button height to equal the 2* lineHeight
        XCTAssertEqual(
            sut.intrinsicContentSize.height,
            (sut.typography.lineHeight * 2) + sut.contentEdgeInsets.vertical
        )

        // Given a label with a single line of attributed text
        sut.titleLabel?.numberOfLines = 1
        sut.setAttributedTitle(
            NSAttributedString(
                string: "Hello World",
                attributes: [.strikethroughStyle: 1]
            ),
            for: .normal
        )
        
        // we expect text to not be nil
        XCTAssertNotNil(sut.currentAttributedTitle)
        // we expect the style to still have strikethrough
        XCTAssertTrue(sut.currentAttributedTitle?.hasUniversalAttribute(key: .strikethroughStyle) ?? false)
        // we expect button height to equal the lineHeight
        sut.layoutIfNeeded()
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight + sut.contentEdgeInsets.vertical)

        // changing the text alignment will restyle the attributed text
        sut.textAlignment = .center
        XCTAssertNotNil(sut.currentAttributedTitle)

        // then if we clear it
        sut.setAttributedTitle(nil, for: .normal)
        
        // we expect it to be nil
        XCTAssertNil(sut.currentTitle)
        XCTAssertNil(sut.currentAttributedTitle)
    }
    
    func testContentSizeDidChange() {
        let sut = makeSUT()
        sut.clear()
        let userInfo = [UIContentSizeCategory.newValueUserInfoKey: UIContentSizeCategory.accessibilityLarge]
        NotificationCenter.default.post(
            name: UIContentSizeCategory.didChangeNotification,
            object: nil,
            userInfo: userInfo
        )
        
        // Button should respond to UIContentSizeCategory.didChangeNotification
        // by adjusting its font size
        XCTAssertTrue(sut.isFontAdjusted)
    }

    func testTestCase() {
        let sut = makeSUT()
        sut.setTitle("First name", for: .normal)

        // we don't expect text case by default
        XCTAssertEqual(sut.typography.textCase, .none)
        XCTAssertEqual(sut.currentTitle, "First name")

        sut.typography = sut.typography.textCase(.lowercase)
        XCTAssertEqual(sut.currentTitle, "first name")

        sut.typography = sut.typography.textCase(.uppercase)
        XCTAssertEqual(sut.currentTitle, "FIRST NAME")

        sut.typography = sut.typography.textCase(.capitalize)
        XCTAssertEqual(sut.currentTitle, "First Name")

        // setting text should apply the text case
        sut.setTitle("john", for: .normal)
        XCTAssertEqual(sut.currentTitle, "John")

        // setting attributed text should also apply the text case
        sut.setAttributedTitle(NSAttributedString(string: "first name", attributes: [.underlineStyle: 1]), for: .normal)
        XCTAssertEqual(sut.currentTitle, "First Name")
    }

    func testCurrentTitle() {
        let sut = makeSUT()

        // given we set a title, we expect to read it back
        sut.setTitle("Press Me", for: .normal)
        XCTAssertEqual(sut.currentTitle, "Press Me")

        // given we set an attributed title, we expect to read it back as both String and AttributedString
        let attributedTitle = NSAttributedString(string: "Press Me", attributes: [.underlineStyle: 1])
        sut.setAttributedTitle(attributedTitle, for: .normal)
        XCTAssertEqual(sut.currentTitle, "Press Me")
        XCTAssertEqual(sut.currentAttributedTitle?.string, "Press Me")
    }

    func testIsEnabled() {
        let sut = makeSUT()
        XCTAssertFalse(sut.isButtonStateChanged)
        sut.isEnabled = false
        XCTAssertTrue(sut.isButtonStateChanged)
    }

    func testIsHighlighted() {
        let sut = makeSUT()
        XCTAssertFalse(sut.isButtonStateChanged)
        sut.isHighlighted = true
        XCTAssertTrue(sut.isButtonStateChanged)
    }

    func testIsSelected() {
        let sut = makeSUT()
        XCTAssertFalse(sut.isButtonStateChanged)
        sut.isSelected = true
        XCTAssertTrue(sut.isButtonStateChanged)
    }
}

private extension TypographyButtonTests {
    func makeSUT(spacing: CGFloat = 0, file: StaticString = #filePath, line: UInt = #line) -> MockButton {
        let typography = Typography(
            fontFamily: Typography.sfProText,
            fontWeight: .regular,
            fontSize: 16,
            lineHeight: 24,
            paragraphSpacing: spacing,
            isFixed: true
        )
        let sut = MockButton(typography: typography)
        sut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
