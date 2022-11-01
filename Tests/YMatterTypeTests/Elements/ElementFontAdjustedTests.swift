//
//  ElementFontAdjustedTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/20/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

protocol FontAdjustable: TraitEnvironmentFlags {
    var isFontAdjusted: Bool { get }
}

extension MockButton: FontAdjustable { }
extension MockLabel: FontAdjustable { }
extension MockTextField: FontAdjustable { }
extension MockTextView: FontAdjustable { }

final class ElementFontAdjustedTests: XCTestCase {
    private let typography = Typography(
        fontFamily: Typography.systemFamily,
        fontWeight: .extraBold,
        fontSize: 32,
        lineHeight: 40,
        textStyle: .title1,
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

    private func _testElement<T: FontAdjustable>(_ sut: T) {
        // if traits haven't changed, then fonts should not be adjusted
        sut.clear()
        sut.traitCollectionDidChange(sut.traitCollection)
        XCTAssertFalse(sut.isFontAdjusted)

        let sameTraits = UITraitCollection.generateSimilarFontTraits(to: sut.traitCollection)

        // If traits unrelated to fonts have changed, then fonts should not be adjusted
        sameTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertFalse(sut.isFontAdjusted)
        }

        let differentTraits = UITraitCollection.generateDifferentFontTraits()

        // If traits have changed, then fonts should only be adjusted when the traits have a different font appearance
        differentTraits.forEach {
            sut.clear()
            sut.traitCollectionDidChange($0)
            XCTAssertEqual(sut.isFontAdjusted, sut.traitCollection.hasDifferentFontAppearance(comparedTo: $0))
        }
    }
}
