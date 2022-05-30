//
//  NSAttributedString+textCaseTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/3/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class NSAttributedStringTextCaseTests: BaseStringTestCase {
    func testNone() {
        let sut = makeSUT()
        sut.forEach { _, value in
            XCTAssertEqual(value.textCase(.none), value)
        }
    }

    func testLowercase() {
        let sut = makeSUT()
        sut.forEach { key, input in
            let output = input.textCase(.lowercase).string
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input.string
            case .word:
                expected = "john"
            case .sentence:
                expected = "the quick brown fox jumped over the lazy dog."
            case .asymmetric:
                expected = "straße"
            }
            XCTAssertEqual(output, expected)
        }
    }

    func testUppercase() {
        let sut = makeSUT()
        sut.forEach { key, input in
            let output = input.textCase(.uppercase).string
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input.string
            case .word:
                expected = "JOHN"
            case .sentence:
                expected = "THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG."
            case .asymmetric:
                expected = "STRASSE"
            }
            XCTAssertEqual(output, expected)
        }
    }

    func testCapitalize() {
        let sut = makeSUT()
        sut.forEach { key, input in
            let output = input.textCase(.capitalize).string
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input.string
            case .word:
                // capitalize behaves strangely over word fragments
                expected = "JoHn"
            case .sentence:
                expected = "The Quick Brown Fox Jumped Over The Lazy Dog."
            case .asymmetric:
                expected = "Straße"
            }
            XCTAssertEqual(output, expected)
        }
    }
}

private extension NSAttributedStringTextCaseTests {
    func makeSUT() -> [TestCase: NSAttributedString] {
        TestCase.allCases.reduce(into: [TestCase: NSAttributedString]()) {
            let text = text(for: $1)
            let attributes = attributes(for: $1)
            switch $1 {
            case .word:
                // Apply attributes to partial string
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.setAttributes(attributes, to: "hn")
                $0[$1] = attributedText
            case .sentence:
                // Apply attributes to partial string
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.setAttributes(attributes, to: "the lazy dog")
                $0[$1] = attributedText
            case .empty, .symbols, .asymmetric:
                // Apply attributes to entire string
                $0[$1] = NSAttributedString(string: text, attributes: attributes)
            }
        }
    }

    func attributes(for testCase: TestCase) -> [NSAttributedString.Key: Any] {
        switch testCase {
        case .empty:
            return [:]
        case .symbols:
            return [.underlineStyle: 1]
        case .word:
            return [.kern: 1.2]
        case .sentence:
            return [
                .foregroundColor: UIColor.systemRed,
                .backgroundColor: UIColor.systemBackground
            ]
        case .asymmetric:
            return [.paragraphStyle: NSParagraphStyle.default.styleWithLineHeight(24)]
        }
    }
}

extension NSMutableAttributedString {
    /// Adds attributes to the first range of text matching `subtext`.
    ///
    /// Internally this uses `addAttributes(:, range:)` using the range of `subtext` within the attributed string.
    /// If the attributed string does not contain `subtext` then the attributed string is not mutated.
    /// - Parameters:
    ///   - attributes: the attributes to add
    ///   - subtext: text within the attributed string to add the attributes.
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], to subtext: String) {
        guard let range = string.range(of: subtext) else { return }

        let safeText = NSString(string: subtext) as String
        addAttributes(attributes, range: NSRange(range, in: safeText))
    }

    /// Sets attributes to the first range of text matching `subtext`.
    ///
    /// Internally this uses `setAttributes(:, range:)` using the range of `subtext` within the attributed string.
    /// If the attributed string does not contain `subtext` then the attributed string is not mutated.
    /// - Parameters:
    ///   - attributes: the attributes to set
    ///   - subtext: text within the attributed string to set the attributes.
    func setAttributes(_ attributes: [NSAttributedString.Key: Any], to subtext: String) {
        guard let range = string.range(of: subtext) else { return }

        let safeText = NSString(string: subtext) as String
        setAttributes(attributes, range: NSRange(range, in: safeText))
    }
}
