//
//  ElementBreakpointAdjustedTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/19/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

protocol TraitEnvironmentFlags: UITraitEnvironment {
    /// Clear all flags set during `traitCollectionDidChange(:)`
    func clear()
}

protocol BreakpointAdjustable: TraitEnvironmentFlags {
    var isBreakpointAdjusted: Bool { get }
}

extension MockButton: BreakpointAdjustable { }
extension MockLabel: BreakpointAdjustable { }
extension MockTextField: BreakpointAdjustable { }
extension MockTextView: BreakpointAdjustable { }

final class ElementBreakpointAdjustedTests: XCTestCase {
    private let typography = Typography(
        fontFamily: Typography.systemFamily,
        fontWeight: .light,
        fontSize: 22,
        lineHeight: 28,
        textStyle: .title3,
        isFixed: true
    )

    func testLabel() {
        let sut = MockLabel(typography: typography)
        _testElement(sut)
    }

    func testButton() {
        let sut = MockButton(typography: typography)
        _testElement(sut)
    }

    func testTextField() {
        let sut = MockTextField(typography: typography)
        _testElement(sut)
    }

    func testTextView() {
        let sut = MockTextView(typography: typography)
        _testElement(sut)
    }

    private func _testElement<T: BreakpointAdjustable>(_ sut: T) {
        // if traits haven't changed, then breakpoints should not be adjusted
        sut.clear()
        sut.traitCollectionDidChange(sut.traitCollection)
        XCTAssertFalse(sut.isBreakpointAdjusted)

        let sameTraits = UITraitCollection.generateSimilarBreakpointTraits(to: sut.traitCollection)

        // If traits unrelated to breakpoints have changed, then breakpoints should not be adjusted
        sameTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertFalse(sut.isBreakpointAdjusted)
        }

        let differentTraits = UITraitCollection.generateDifferentBreakpointTraits()

        // If traits have changed, then breakpoints should only be adjusted when the traits have a different breakpoint
        differentTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertEqual(sut.isBreakpointAdjusted, sut.traitCollection.hasDifferentBreakpoint(comparedTo: $0))
        }
    }
}
