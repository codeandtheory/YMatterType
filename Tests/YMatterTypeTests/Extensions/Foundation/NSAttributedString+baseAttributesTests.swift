//
//  NSAttributedString+baseAttributesTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/2/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class NSAttributedStringBaseAttributesTests: XCTestCase {
    private let regularColor = UIColor.label
    private let regularFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    private lazy var regularAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: regularColor,
        .font: regularFont
    ]

    private let boldFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    private let boldColor = UIColor.systemTeal
    private let boldRange = NSRange(location: 4, length: 5)
    private lazy var boldAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: boldColor,
        .font: boldFont
    ]

    func test() {
        let sut = makeSUT()
        let updated = sut.attributedString(with: regularAttributes)

        for i in 0..<updated.length {
            XCTAssertEqual(
                updated.attribute(.foregroundColor, at: i, effectiveRange: nil) as? UIColor,
                boldRange.contains(i) ? boldColor : regularColor
            )
            XCTAssertEqual(
                updated.attribute(.font, at: i, effectiveRange: nil) as? UIFont,
                boldRange.contains(i) ? boldFont : regularFont
            )
        }
    }

    func testReapply() {
        let sut = makeSUT()
        var updated = sut.attributedString(with: regularAttributes)
        updated = updated.attributedString(with: regularAttributes)

        for i in 0..<updated.length {
            XCTAssertEqual(
                updated.attribute(.foregroundColor, at: i, effectiveRange: nil) as? UIColor,
                boldRange.contains(i) ? boldColor : regularColor
            )
            XCTAssertEqual(
                updated.attribute(.font, at: i, effectiveRange: nil) as? UIFont,
                boldRange.contains(i) ? boldFont : regularFont
            )
        }
    }
}

private extension NSAttributedStringBaseAttributesTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> NSAttributedString {
        let sut = NSMutableAttributedString(string: "The doctor is in.")
        sut.addAttributes(boldAttributes, range: boldRange)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
