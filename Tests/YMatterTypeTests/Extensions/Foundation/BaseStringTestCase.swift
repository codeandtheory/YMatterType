//
//  BaseStringTestCase.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/3/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

class BaseStringTestCase: XCTestCase {
    enum TestCase: CaseIterable {
        case empty
        case symbols
        case word
        case sentence
        case asymmetric
    }

    func text(for testCase: TestCase) -> String {
        switch testCase {
        case .empty:
            return ""
        case .symbols:
            return "!@#$%^&*()"
        case .word:
            return "John"
        case .sentence:
            return "The quick brown fox jumped over the lazy dog."
        case .asymmetric:
            return "straße"
        }
    }
}
