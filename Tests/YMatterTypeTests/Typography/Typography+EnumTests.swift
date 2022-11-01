//
//  Typography+EnumTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/17/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyEnumTests: XCTestCase {
    func test_fontWeightInit_garbageReturnsNil() {
        ["", "nonsense", "garbage", "not a weight"].forEach {
            XCTAssertNil(Typography.FontWeight($0))
        }
    }

    func test_fontWeightInit_isCaseInsensitive() {
        ["Regular", "regular", "REGULAR", "ReGuLaR"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .regular)
        }

        ["Semibold", "semibold", "SEMIBOLD", "SemiBold"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .semibold)
        }
    }

    func test_fontWeightInit_acceptsSynonyms() {
        ["ExtraLight", "UltraLight"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .extraLight)
        }

        ["Normal", "Regular"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .regular)
        }

        ["SemiBold", "DemiBold"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .semibold)
        }

        ["ExtraBold", "UltraBold"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .extraBold)
        }

        ["Heavy", "Black"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .black)
        }

        ["ExtraBlack", "UltraBlack"].forEach {
            XCTAssertEqual(Typography.FontWeight($0), .extraBlack)
        }
    }

    func test_fontWeightInit_acceptsFontFamilyWeightNames() {
        let sut = DefaultFontFamily(familyName: "Any")

        for weight in sut.supportedWeights {
            let weightName = sut.weightName(for: weight)
            XCTAssertEqual(Typography.FontWeight(weightName), weight)
        }
    }
}
