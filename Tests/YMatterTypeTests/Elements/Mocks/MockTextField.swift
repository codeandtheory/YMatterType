//
//  MockTextField.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/19/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation
@testable import YMatterType

final class MockTextField: TypographyTextField {
    var isFontAdjusted: Bool = false
    var isColorAdjusted: Bool = false
    var isBreakpointAdjusted: Bool = false

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
}
