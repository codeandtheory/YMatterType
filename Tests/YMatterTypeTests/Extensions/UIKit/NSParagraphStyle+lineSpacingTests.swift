//
//  NSParagraphStyle+lineSpacingTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest

final class NSParagraphStyleLineSpacingTests: XCTestCase {
    func testStyleWithLineSpacing() {
        let (sut, _, spacings, _, _) = makeSUT()
        spacings.forEach {
            XCTAssertEqual(sut.styleWithLineSpacing($0).lineSpacing, $0)
            XCTAssertEqual(NSParagraphStyle.default.styleWithLineSpacing($0).lineSpacing, $0)
            XCTAssertEqual(NonMutableParagraphStyle().styleWithLineSpacing($0).lineSpacing, $0)
        }
    }

    func testStyleWithLineHeightMultiple() {
        let (sut, _, _, multiples, _) = makeSUT()
        multiples.forEach {
            XCTAssertEqual(sut.styleWithLineHeightMultiple($0).lineHeightMultiple, $0)
            XCTAssertEqual(NSParagraphStyle.default.styleWithLineHeightMultiple($0).lineHeightMultiple, $0)
            XCTAssertEqual(NonMutableParagraphStyle().styleWithLineHeightMultiple($0).lineHeightMultiple, $0)
        }
    }

    func testStyleWithAlignment() {
        let (sut, alignments, _, _, _) = makeSUT()
        alignments.forEach {
            XCTAssertEqual(sut.styleWithAlignment($0).alignment, $0)
            XCTAssertEqual(NSParagraphStyle.default.styleWithAlignment($0).alignment, $0)
            XCTAssertEqual(NonMutableParagraphStyle().styleWithAlignment($0).alignment, $0)
        }
    }

    func testStyleWithLineHeight() {
        let (sut, _, _, _, lineHeights) = makeSUT()
        lineHeights.forEach {
            let indent = CGFloat(Int.random(in: 1..<10))
            let spacing = CGFloat(Int.random(in: 10..<32))
            let style1 = sut.styleWithLineHeight($0, indent: indent, spacing: spacing)
            let style2 = NSParagraphStyle.default.styleWithLineHeight($0, indent: indent)
            let style3 = NonMutableParagraphStyle().styleWithLineHeight($0, spacing: spacing)

            for style in [style1, style2, style3] {
                XCTAssertEqual(style.minimumLineHeight, $0)
                XCTAssertEqual(style.maximumLineHeight, $0)
            }

            XCTAssertEqual(style1.firstLineHeadIndent, indent)
            XCTAssertEqual(style2.firstLineHeadIndent, indent)
            XCTAssertEqual(style3.firstLineHeadIndent, .zero)

            XCTAssertEqual(style1.paragraphSpacing, spacing)
            XCTAssertEqual(style2.paragraphSpacing, .zero)
            XCTAssertEqual(style3.paragraphSpacing, spacing)
        }
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension NSParagraphStyleLineSpacingTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (NSParagraphStyle, [NSTextAlignment], [CGFloat], [CGFloat], [CGFloat]) {
        let style = generateStyle()
        let alignments: [NSTextAlignment] = [
            .left,
            .center,
            .right,
            .justified,
            .natural
        ]
        let spacings: [CGFloat] = [
            -2.0,
            0.0,
            1.0,
            2.0,
            7.5,
            16.0
        ]
        let multiples: [CGFloat] = [
            0.81,
            0.94,
            1.00,
            1.07,
            1.50,
            2.00
        ]
        let lineHeights: [CGFloat] = [
            12,
            14,
            16,
            18,
            24,
            28,
            32,
            64
        ]

        trackForMemoryLeak(style, file: file, line: line)
        return (style, alignments, spacings, multiples, lineHeights)
    }

    func generateStyle() -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        style.lineHeightMultiple = 0.94
        style.minimumLineHeight = 16
        style.maximumLineHeight = 16
        style.alignment = .center
        style.headIndent = 16
        style.tailIndent = 16
        style.paragraphSpacing = 12
        style.lineBreakMode = .byWordWrapping
        style.lineBreakStrategy = .pushOut
        return style
    }
}

// This tests the ternary fallback operator of the following line in NSParagraphStyle+lineSpacing.swift:
// let paragraphStyle = (mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
private final class NonMutableParagraphStyle: NSParagraphStyle {
    override func mutableCopy() -> Any {
        // Don't return NSMutableParagraphStyle
        return self
    }
}
