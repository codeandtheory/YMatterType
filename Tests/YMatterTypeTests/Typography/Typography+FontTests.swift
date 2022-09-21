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
            // The returned line height should not exceed th requested maximum
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
                // The returned line height should not exceed th requested maximum
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
}

struct AppleSDGothicNeoInfo: FontFamily {
    let familyName: String = "AppleSDGothicNeo"
    
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
