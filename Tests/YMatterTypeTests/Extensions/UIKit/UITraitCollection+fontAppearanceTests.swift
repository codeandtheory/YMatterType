//
//  UITraitCollection+fontAppearanceTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 8/12/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import XCTest

final class UITraitCollectionFontAppearanceTests: XCTestCase {
    func testSelf() {
        let (defaultTraits, sameTraits, differentTraits) = makeSUT()
        // no trait collection should have a different font appearance to itself
        XCTAssertFalse(defaultTraits.hasDifferentFontAppearance(comparedTo: defaultTraits))
        
        sameTraits.forEach {
            XCTAssertFalse($0.hasDifferentFontAppearance(comparedTo: $0))
        }
        
        differentTraits.forEach {
            XCTAssertFalse($0.hasDifferentFontAppearance(comparedTo: $0))
        }
    }
    
    func testSameTraits() {
        let (defaultTraits, sameTraits, _) = makeSUT()
        // Traits that do not affect font appearance should not be considered different
        sameTraits.forEach {
            XCTAssertFalse(defaultTraits.hasDifferentFontAppearance(comparedTo: $0))
            XCTAssertFalse($0.hasDifferentFontAppearance(comparedTo: defaultTraits))
        }
        
        let allSameTraits = UITraitCollection(traitsFrom: sameTraits)
        XCTAssertFalse(defaultTraits.hasDifferentFontAppearance(comparedTo: allSameTraits))
        XCTAssertFalse(allSameTraits.hasDifferentFontAppearance(comparedTo: defaultTraits))
    }
    
    func testDifferentTraits() {
        let (defaultTraits, _, differentTraits) = makeSUT()
        // Traits that do affect font appearance should be considered different
        differentTraits.forEach {
            XCTAssertTrue(defaultTraits.hasDifferentFontAppearance(comparedTo: $0))
            XCTAssertTrue($0.hasDifferentFontAppearance(comparedTo: defaultTraits))
        }
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension UITraitCollectionFontAppearanceTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UITraitCollection, [UITraitCollection], [UITraitCollection]) {
        let defaultTraits = generateDefaultTraits()
        let sameTraits = generateSimilarTraits()
        let differentTraits = UITraitCollection.generateDifferentFontTraits()

        trackForMemoryLeak(defaultTraits, file: file, line: line)
        sameTraits.forEach { trackForMemoryLeak($0, file: file, line: line) }

        return (defaultTraits, sameTraits, differentTraits)
    }

    func generateDefaultTraits() -> UITraitCollection {
        UITraitCollection(traitsFrom: [
            .default,
            UITraitCollection(horizontalSizeClass: .regular),
            UITraitCollection(verticalSizeClass: .regular),
            UITraitCollection(userInterfaceIdiom: .phone),
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(accessibilityContrast: .normal)
        ])
    }
    
    // Traits affecting a variety of things but not Dynamic Type Size or Bold Text
    func generateSimilarTraits() -> [UITraitCollection] {
        // return each of these traits combined with startingTraits
        return [
            UITraitCollection(horizontalSizeClass: .compact),
            UITraitCollection(verticalSizeClass: .compact),
            UITraitCollection(userInterfaceIdiom: .pad),
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(accessibilityContrast: .high)
        ].map({ UITraitCollection(traitsFrom: [.default, $0]) })
    }
}
// swiftlint:enable large_tuple
