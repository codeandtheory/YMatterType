//
//  UITraitCollection+breakpointTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/18/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest

final class UITraitCollectionBreakpointTests: XCTestCase {
    // Sample starting values for horizontal and vertical size classes
    // (typical for phone in portrait mode)
    private let startingTraits = UITraitCollection.startingBreakpointTraits

    func testSelf() {
        let (defaultTraits, sameTraits, differentTraits) = makeSUT()
        // no trait collection should have a different breakpoint to itself
        XCTAssertFalse(defaultTraits.hasDifferentBreakpoint(comparedTo: defaultTraits))

        sameTraits.forEach {
            XCTAssertFalse($0.hasDifferentBreakpoint(comparedTo: $0))
        }

        differentTraits.forEach {
            XCTAssertFalse($0.hasDifferentBreakpoint(comparedTo: $0))
        }
    }

    func testSameTraits() {
        let (defaultTraits, sameTraits, _) = makeSUT()
        // Traits that do not affect breakpoint should not be considered different
        sameTraits.forEach {
            XCTAssertFalse(defaultTraits.hasDifferentBreakpoint(comparedTo: $0))
            XCTAssertFalse($0.hasDifferentBreakpoint(comparedTo: defaultTraits))
        }

        let allSameTraits = UITraitCollection(traitsFrom: sameTraits)
        XCTAssertFalse(defaultTraits.hasDifferentBreakpoint(comparedTo: allSameTraits))
        XCTAssertFalse(allSameTraits.hasDifferentBreakpoint(comparedTo: defaultTraits))
    }

    func testDifferentTraits() {
        let (defaultTraits, _, differentTraits) = makeSUT()
       // Traits that do affect breakpoint should be considered different
        differentTraits.forEach {
            XCTAssertTrue(defaultTraits.hasDifferentBreakpoint(comparedTo: $0))
            XCTAssertTrue($0.hasDifferentBreakpoint(comparedTo: defaultTraits))
        }
    }
}

// We use large tuples in makeSUT()
// swiftlint:disable large_tuple

private extension UITraitCollectionBreakpointTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UITraitCollection, [UITraitCollection], [UITraitCollection]) {
        let defaultTraits = generateDefaultTraits()
        let sameTraits = generateSimilarTraits()
        let differentTraits = UITraitCollection.generateDifferentBreakpointTraits()

        trackForMemoryLeak(defaultTraits, file: file, line: line)
        sameTraits.forEach { trackForMemoryLeak($0, file: file, line: line) }

        return (defaultTraits, sameTraits, differentTraits)
    }

    func generateDefaultTraits() -> UITraitCollection {
        UITraitCollection(traitsFrom: [
            startingTraits,
            UITraitCollection(userInterfaceIdiom: .phone),
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(accessibilityContrast: .normal),
            UITraitCollection(legibilityWeight: .regular),
            UITraitCollection(preferredContentSizeCategory: .large)
        ])
    }

    // Traits affecting a variety of things but not traits that could affect breakpoints
    func generateSimilarTraits() -> [UITraitCollection] {
        // return each of these traits combined with startingTraits
        return [
            UITraitCollection(userInterfaceIdiom: .pad),
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(accessibilityContrast: .high),
            UITraitCollection(legibilityWeight: .bold),
            UITraitCollection(preferredContentSizeCategory: .extraLarge)
        ].map({ UITraitCollection(traitsFrom: [startingTraits, $0]) })
    }
}
