//
//  TypographyLabelRepresentableTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/20/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyLabelRepresentableTests: XCTestCase {
    enum Constants {
        static let helloWorldText = "Hello, World"
        static let goodbyeText = "Goodbye!"
        static let fontSize = CGFloat.random(in: 18...36)
        static let textColor: UIColor = .systemPurple
    }

    func test_getLabel_deliversLabel() {
        // Given
        let text = Constants.helloWorldText
        let typography: Typography = .smallBody.fontSize(Constants.fontSize)
        let textColor = Constants.textColor
        let sut = TypographyLabelRepresentable(text: text, typography: typography) { label in
            label.textColor = textColor
        }

        // When
        let label = sut.getLabel()

        // Then
        XCTAssertEqual(label.text, text)
        XCTAssertTypographyEqual(label.typography, typography)
        XCTAssertEqual(label.numberOfLines, 1)
        XCTAssertEqual(label.textColor, textColor)
    }

    func test_updateLabel_updatesLabel() {
        // Given
        let text = Constants.goodbyeText
        let typography: Typography = .bodyBold.fontSize(Constants.fontSize)
        let textColor = Constants.textColor
        var sut = TypographyLabelRepresentable(text: Constants.helloWorldText, typography: .smallBody)
        let label = sut.getLabel()
        XCTAssertNotEqual(label.text, text)
        XCTAssertNotEqual(label.typography.fontSize, typography.fontSize)
        XCTAssertNotEqual(label.typography.fontWeight, typography.fontWeight)
        XCTAssertNotEqual(label.textColor, textColor)

        // When
        sut.text = text
        sut.typography = typography
        sut.configureTextStyleLabel = { label in
            label.textColor = textColor
        }
        sut.updateLabel(label)

        // Then
        XCTAssertEqual(label.text, text)
        XCTAssertTypographyEqual(label.typography, typography)
        XCTAssertEqual(label.textColor, textColor)
    }
}
