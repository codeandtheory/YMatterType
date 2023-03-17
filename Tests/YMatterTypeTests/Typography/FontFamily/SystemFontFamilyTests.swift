//
//  SystemFontFamilyTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 9/28/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class SystemFontFamilyTests: XCTestCase {
    func testFont() throws {
        let (sut, pointSizes, traitCollections) = makeSUT()
        let systemFont = UIFont.systemFont(ofSize: 12)
        
        for weight in Typography.FontWeight.allCases {
            for pointSize in pointSizes {
                for traitCollection in traitCollections {
                    let font = sut.font(for: weight, pointSize: pointSize, compatibleWith: traitCollection)
                    XCTAssertEqual(font.familyName, systemFont.familyName)
                    XCTAssertEqual(font.pointSize, pointSize)
                }
            }
        }
    }
    
    func testFamilyName() {
        let (sut, _, _) = makeSUT()
        XCTAssertTrue(sut.familyName.isEmpty)
    }

    func test_accessibilityWeight_deliversCorrectWeight() {
        let (sut, _, _) = makeSUT()
        let lightWeights: [Typography.FontWeight] = [.ultralight, .thin, .light]
        let midWeights: [Typography.FontWeight] = [.regular, .medium, .semibold]
        let heavyWeights: [Typography.FontWeight] = [.bold, .heavy, .black]

        for weight in lightWeights {
            XCTAssertEqual(sut.accessibilityBoldWeight(for: weight).rawValue, weight.rawValue + 100)
        }

        for weight in midWeights {
            XCTAssertEqual(sut.accessibilityBoldWeight(for: weight).rawValue, weight.rawValue + 200)
        }

        for weight in heavyWeights {
            XCTAssertEqual(sut.accessibilityBoldWeight(for: weight), .black)
        }
    }

    func test_layout_deliversCorrectFont() throws {
        let (sut, _, traitCollections) = makeSUT()

        for weight in Typography.systemFamily.supportedWeights {
            for traitCollection in traitCollections {
                let typography = Typography(fontFamily: sut, fontWeight: weight, fontSize: 16, lineHeight: 24)
                let layoutDynamic = typography.generateLayout(compatibleWith: traitCollection)
                let layoutFixed = typography.fixed.generateLayout(compatibleWith: traitCollection)
                XCTAssertEqual(layoutDynamic.font.fontName, layoutFixed.font.fontName)
            }
        }
    }

    func test_layoutWithLegibilityWeightBold_deliversHeavierFont() throws {
        // Given
        let (sut, _, _) = makeSUT()
        let traitRegular = UITraitCollection(legibilityWeight: .regular)
        let traitBold = UITraitCollection(legibilityWeight: .bold)
        var weights = Typography.systemFamily.supportedWeights
        weights.removeLast() // don't consider .black because we cannot go heavier

        for weight in weights {
            // When
            let typography = Typography(fontFamily: sut, fontWeight: weight, fontSize: 16, lineHeight: 24)
            let layoutRegular = typography.generateLayout(compatibleWith: traitRegular)
            let layoutBold = typography.generateLayout(compatibleWith: traitBold)

            let weightRegular = try XCTUnwrap(self.weight(from: layoutRegular.font))
            let weightBold = try XCTUnwrap(self.weight(from: layoutBold.font))

            // Then
            XCTAssertGreaterThan(weightBold.rawValue, weightRegular.rawValue)
        }
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension SystemFontFamilyTests {
    func makeSUT() -> (FontFamily, [CGFloat], [UITraitCollection?]) {
        let sut = Typography.systemFamily
        let pointSizes: [CGFloat] = [10, 12, 14, 16, 18, 24, 28, 32]
        let traitCollections: [UITraitCollection?] = [
            nil,
            UITraitCollection(legibilityWeight: .unspecified),
            UITraitCollection(legibilityWeight: .regular),
            UITraitCollection(legibilityWeight: .bold)
        ]
        return (sut, pointSizes, traitCollections)
    }

    func weight(from font: UIFont) -> Typography.FontWeight? {
        guard let weightString = font.fontName.components(separatedBy: "-").last else {
            return nil
        }

        switch weightString.lowercased(with: Locale(identifier: "en_US")) {
        case "ultralight", "extralight":
            return .ultralight
        case "thin":
            return .thin
        case "light":
            return .light
        case "regular":
            return .regular
        case "medium":
            return .medium
        case "semibold", "demibold":
            return .semibold
        case "bold":
            return .bold
        case "heavy", "extrabold":
            return .heavy
        case "black":
            return .black
        default:
            return nil
        }
    }
}
