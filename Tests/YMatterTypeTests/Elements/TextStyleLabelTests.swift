//
//  TextStyleLabelTests.swift
//  YMatterTypeTests
//
//  Created by Virginia Pujols on 1/26/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TextStyleLabelTests: XCTestCase {
    enum Constants {
        static let helloWorldText = "Hello, World"
        static let fontSize = CGFloat.random(in: 10...60)
    }
    
    func testTextStyleLabelSingleLine() {
        let expectedText = Constants.helloWorldText
        let expectedTypography = Typography.systemLabel.fontSize(Constants.fontSize)

        // Given a TextStyleLabel with a single line of text
        let sut = TextStyleLabel(
            expectedText,
            typography: expectedTypography,
            configuration: { (label: TypographyLabel) in
                label.lineBreakMode = .byTruncatingMiddle
            }
        )

        // we expect a value
        XCTAssertNotNil(sut)
        
        // we expect the text to match the expected
        XCTAssertEqual(sut.text, expectedText)
        
        // we expect the font to match the expected
        XCTAssertTypographyEqual(sut.typography, expectedTypography)

        // we expect the configuration closusure to update the label
        let labelToUpdate = TypographyLabel(typography: expectedTypography)
        XCTAssertNotEqual(labelToUpdate.lineBreakMode, .byTruncatingMiddle)

        sut.configureTextStyleLabel?(labelToUpdate)
        XCTAssertEqual(labelToUpdate.lineBreakMode, .byTruncatingMiddle)
    }

    func test_getLabel_deliversRepresentable() throws {
        let expectedText = Constants.helloWorldText
        let expectedTypography = Typography.systemLabel.fontSize(Constants.fontSize)

        // Given a TextStyleLabel with a single line of text
        let sut = TextStyleLabel(
            expectedText,
            typography: expectedTypography
        )

        // When
        let label = try XCTUnwrap(sut.getLabel() as? TypographyLabelRepresentable)

        // Then
        XCTAssertEqual(label.text, expectedText)
        XCTAssertTypographyEqual(label.typography, expectedTypography)
    }
}
