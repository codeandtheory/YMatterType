//
//  Typography+FontTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/24/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class TypographyFontTests: XCTestCase {
    private let sizes: [(fontSize: CGFloat, lineHeight: CGFloat)] = [
        (12, 16),
        (14, 16),
        (16, 20),
        (18, 24),
        (20, 28),
        (24, 32)
    ]

    private let scaleFactors: [CGFloat] = [1.25, 1.5, 1.75, 2.0]

    func testGenerateLayout() {
        let fontFamily = AppleSDGothicNeoInfo()
        
        Typography.FontWeight.allCases.forEach {
            for isFixed in [true, false] {
                for letterSpacing in [-0.5, 0, 1.2] {
                    let typography = Typography(
                        fontFamily: fontFamily,
                        fontWeight: $0,
                        fontSize: 16,
                        lineHeight: 24,
                        letterSpacing: letterSpacing,
                        isFixed: isFixed
                    )
                    let layout = typography.generateLayout(compatibleWith: .default)
                    XCTAssertNotNil(layout)
                    XCTAssertEqual(layout.kerning, letterSpacing)
                }
            }
        }
    }
        
    func testParagraphStyle() {
        let fontFamily = DefaultFontFamily(familyName: "HelveticaNeue", style: .italic)
        
        sizes.forEach {
            let typography = Typography(
                fontFamily: fontFamily,
                fontWeight: .bold,
                fontSize: $0.fontSize,
                lineHeight: $0.lineHeight
            )

            // line height of style, typography, and layout should match
            let layout = typography.generateLayout(compatibleWith: .default)
            let style = layout.paragraphStyle
            
            XCTAssertEqual(style.minimumLineHeight, typography.lineHeight)
            XCTAssertEqual(style.maximumLineHeight, typography.lineHeight)
            XCTAssertEqual(style.minimumLineHeight, layout.lineHeight)
            XCTAssertEqual(style.maximumLineHeight, layout.lineHeight)
        }
    }

#if os(iOS)
    func testMaximumPointSize() {
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        
        sizes.forEach {
            let typography = Typography(
                fontFamily: fontFamily,
                fontWeight: .bold,
                fontSize: $0.fontSize,
                lineHeight: $0.lineHeight
            )

            // Given we request a layout with a maximum point size
            // (at the largest supported Dynamic Type size)
            let layout = typography.generateLayout(
                maximumPointSize: $0.fontSize * 2,
                compatibleWith: traits
            )
            
            // The returned font should not exceed the requested maximum
            XCTAssertEqual(layout.font.pointSize, $0.fontSize * 2)
            // The returned line height should not exceed the requested maximum
            XCTAssertEqual(layout.lineHeight, $0.lineHeight * 2)
            // baselineOffset should be >= 0 and pixel-aligned
            XCTAssertGreaterThanOrEqual(layout.baselineOffset, 0)
            XCTAssertEqual(layout.baselineOffset.ceiled(), layout.baselineOffset)
        }
    }

    func testMaximumScaleFactor() {
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)

        sizes.forEach { size in
            let typography = Typography(
                fontFamily: fontFamily,
                fontWeight: .bold,
                fontSize: size.fontSize,
                lineHeight: size.lineHeight
            )

            scaleFactors.forEach { scaleFactor in
                // Given we request a layout with a maximum point size
                // (at the largest supported Dynamic Type size)
                let layout = typography.generateLayout(
                    maximumScaleFactor: scaleFactor,
                    compatibleWith: traits
                )

                // The returned font should not exceed the requested maximum
                XCTAssertEqual(layout.font.pointSize, size.fontSize * scaleFactor)
                // The returned line height should not exceed the requested maximum
                XCTAssertEqual(layout.lineHeight, size.lineHeight * scaleFactor)
                // baselineOffset should be >= 0 and pixel-aligned
                XCTAssertGreaterThanOrEqual(layout.baselineOffset, 0)
                XCTAssertEqual(layout.baselineOffset.ceiled(), layout.baselineOffset)
            }
        }
    }

    func testIntrinsicMaximumScaleFactor() {
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)

        sizes.forEach { size in
            scaleFactors.forEach { scaleFactor in
                // Given we build a typography with a built-in max scale factor
                let typography = Typography(
                    fontFamily: fontFamily,
                    fontWeight: .bold,
                    fontSize: size.fontSize,
                    lineHeight: size.lineHeight,
                    maximumScaleFactor: scaleFactor
                )

               // When we request a layout without specifying any further max
                // (at the largest supported Dynamic Type size)
                let layout = typography.generateLayout(compatibleWith: traits)

                // The returned font should not exceed the requested maximum
                XCTAssertEqual(layout.font.pointSize, size.fontSize * scaleFactor)
                // The returned line height should not exceed the requested maximum
                XCTAssertEqual(layout.lineHeight, size.lineHeight * scaleFactor)
                // baselineOffset should be >= 0 and pixel-aligned
                XCTAssertGreaterThanOrEqual(layout.baselineOffset, 0)
                XCTAssertEqual(layout.baselineOffset.ceiled(), layout.baselineOffset)
            }
        }
    }

    func testScaleLessThanMaximum() {
        let fontFamily = DefaultFontFamily(familyName: "Menlo")
        let traits = UITraitCollection(preferredContentSizeCategory: .extraExtraLarge) // 2 sizes above default

        sizes.forEach {
            let typography = Typography(
                fontFamily: fontFamily,
                fontWeight: .bold,
                fontSize: $0.fontSize,
                lineHeight: $0.lineHeight
            )

            // Given we request a layout with a maximum scale factor that we do not expect to reach
            // (at the largest supported Dynamic Type size)
            let layout = typography.generateLayout(
                maximumScaleFactor: 2,
                compatibleWith: traits
            )

            // The returned font should be more than 1x but less than 2x
            XCTAssertGreaterThan(layout.font.pointSize, $0.fontSize)
            XCTAssertLessThan(layout.font.pointSize, $0.fontSize * 2)
            // The returned line height should be more than 1x but less than 2x
            XCTAssertGreaterThan(layout.lineHeight, $0.lineHeight)
            XCTAssertLessThan(layout.lineHeight, $0.lineHeight * 2)
            // baselineOffset should be >= 0 and pixel-aligned
            XCTAssertGreaterThanOrEqual(layout.baselineOffset, 0)
            XCTAssertEqual(layout.baselineOffset.ceiled(), layout.baselineOffset)
        }
    }
#endif

    func test_maximumPointSize() {
        // Given
        let factors: [CGFloat?] = [nil, 1.5, 2.0, 2.5]

        factors.forEach {
            let pointSize = CGFloat(Int.random(in: 10...32))
            let sut = Typography(
                fontFamily: AppleSDGothicNeoInfo(),
                fontWeight: .bold,
                fontSize: pointSize,
                lineHeight: ceil(pointSize * 1.4),
                maximumScaleFactor: $0
            )

            let maximumPointSize = sut.maximumPointSize
            if let factor = $0 {
                XCTAssertEqual(maximumPointSize, pointSize * factor)
            } else {
                XCTAssertNil(maximumPointSize)
            }
        }
    }

    func test_getMaximumPointSize_withoutMaximumScaleFactor() {
        // Given
        let sut = Typography(
            fontFamily: AppleSDGothicNeoInfo(),
            fontWeight: .bold,
            fontSize: 12,
            lineHeight: 24
        )
        let maximumPointSize = CGFloat(Int.random(in: 16...48))

        // Then
        XCTAssertNil(sut.maximumPointSize)
        XCTAssertNil(sut.getMaximumPointSize(nil))
        XCTAssertEqual(sut.getMaximumPointSize(maximumPointSize), maximumPointSize)
    }

    func test_getMaximumPointSize_withMaximumScaleFactor() {
        // Given
        let sut = Typography(
            fontFamily: AppleSDGothicNeoInfo(),
            fontWeight: .bold,
            fontSize: 12,
            lineHeight: 24,
            maximumScaleFactor: 2
        )
        let lowerPointSize = CGFloat(Int.random(in: 13..<24))
        let higherPointSize = CGFloat(Int.random(in: 25...48))

        // Then
        XCTAssertEqual(sut.maximumPointSize, 24)
        XCTAssertEqual(sut.getMaximumPointSize(nil), sut.maximumPointSize)
        XCTAssertEqual(sut.getMaximumPointSize(lowerPointSize), lowerPointSize)
        XCTAssertEqual(sut.getMaximumPointSize(higherPointSize), sut.maximumPointSize)
    }
}

struct AppleSDGothicNeoInfo: FontFamily {
    let familyName: String = "AppleSDGothicNeo"

    // This font family doesn't support weights higher than Bold
    var supportedWeights: [Typography.FontWeight] = [.ultralight, .thin, .light, .regular, .medium, .semibold, .bold]

    func weightName(for weight: Typography.FontWeight) -> String {
        switch weight {
        case .ultralight:
            return "UltraLight" // some fonts use ExtraLight
        case .thin:
            return "Thin"
        case .light:
            return "Light"
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "SemiBold" // some fonts use DemiBold
        case .bold, .heavy, .black:
            // this font family doesn't support weights higher than Bold
            return "Bold"
        }
    }
}
