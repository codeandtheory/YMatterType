//
//  String+textCaseTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/2/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class StringTextCaseTests: BaseStringTestCase {
    func testNone() {
        let sut = makeSUT()
        sut.forEach { _, value in
            XCTAssertEqual(value.textCase(.none), value)
        }
    }

    func testLowercase() {
        let sut = makeSUT()

        sut.forEach { key, input in
            let output = input.textCase(.lowercase)
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input
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
            let output = input.textCase(.uppercase)
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input
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
            let output = input.textCase(.capitalize)
            let expected: String
            switch key {
            case .empty, .symbols:
                expected = input
            case .word:
                expected = "John"
            case .sentence:
                expected = "The Quick Brown Fox Jumped Over The Lazy Dog."
            case .asymmetric:
                expected = "Straße"
            }
            XCTAssertEqual(output, expected)
        }
    }
}

private extension StringTextCaseTests {
    func makeSUT() -> [TestCase: String] {
        TestCase.allCases.reduce(into: [TestCase: String]()) {
            $0[$1] = text(for: $1)
        }
    }
}
