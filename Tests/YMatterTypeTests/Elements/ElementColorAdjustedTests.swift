//
//  ElementColorAdjustedTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/20/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

protocol ColorAdjustable: TraitEnvironmentFlags {
    var isColorAdjusted: Bool { get }
}

extension MockButton: ColorAdjustable { }
extension MockLabel: ColorAdjustable { }
extension MockTextField: ColorAdjustable { }
extension MockTextView: ColorAdjustable { }

final class ElementColorAdjustedTests: XCTestCase {
    private let typography = Typography(
        fontFamily: Typography.sfProDisplay,
        fontWeight: .medium,
        fontSize: 24,
        lineHeight: 32,
        textStyle: .title2,
        isFixed: true
    )

    override func setUp() async throws {
        try await super.setUp()
        try UIFont.register(name: "SF-Pro-Display-Medium")
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try UIFont.unregister(name: "SF-Pro-Display-Medium")
    }

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

    private func _testElement<T: ColorAdjustable>(_ sut: T) {
        // if traits haven't changed, then colors should not be adjusted
        sut.clear()
        sut.traitCollectionDidChange(sut.traitCollection)
        XCTAssertFalse(sut.isColorAdjusted)

        let sameTraits = UITraitCollection.generateSimilarColorTraits(to: sut.traitCollection)

        // If traits unrelated to colors have changed, then colors should not be adjusted
        sameTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertFalse(sut.isColorAdjusted)
        }

        let differentTraits = UITraitCollection.generateDifferentColorTraits()

        // If traits have changed, then colors should only be adjusted when the traits have a different color appearance
        differentTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertEqual(sut.isColorAdjusted, sut.traitCollection.hasDifferentColorAppearance(comparedTo: $0))
        }
    }
}
