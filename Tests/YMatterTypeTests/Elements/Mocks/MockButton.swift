//
//  MockButton.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/19/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit
@testable import YMatterType

final class MockButton: TypographyButton {
    var isFontAdjusted: Bool = false
    var isColorAdjusted: Bool = false
    var isBreakpointAdjusted: Bool = false
    var isButtonStateChanged: Bool = false
    
    func clear() {
        isFontAdjusted = false
        isColorAdjusted = false
        isBreakpointAdjusted = false
    }

    override func adjustFonts() {
        super.adjustFonts()
        isFontAdjusted = true
    }

    override func adjustColors() {
        super.adjustColors()
        isColorAdjusted = true
    }

    override func adjustBreakpoint() {
        super.adjustBreakpoint()
        isBreakpointAdjusted = true
    }

    var paragraphStyle: NSParagraphStyle {
        guard let attributedText = currentAttributedTitle,
              attributedText.length > 0,
              let style = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil)
                as? NSParagraphStyle else {
            return NSParagraphStyle.default
        }

        return style
    }

    override func buttonStateDidChange() {
        super.buttonStateDidChange()
        isButtonStateChanged = true
    }
}
