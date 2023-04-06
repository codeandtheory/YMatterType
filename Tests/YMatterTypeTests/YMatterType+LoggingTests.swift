//
//  YMatterType+LoggingTests.swift
//  YMatterType
//
//  Created by Sahil Saini on 04/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class YMatterTypeLoggingTests: XCTestCase {
    func testDefaults() {
        XCTAssertTrue(YMatterType.isLoggingEnabled)
    }
}
