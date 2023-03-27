//
//  String+textSize.swift
//  YMatterType
//
//  Created by Sahil Saini on 27/03/23.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit
import Foundation

extension String {
    /// Returns size of the string
    /// - Parameters:
    ///   - typography: Typography to be used to calculate string size
    ///   - traitCollection: Trait collection to apply
    /// - Returns: Size of the string
    public func size(
        withTypography typography: Typography,
        compatibleWith traitCollection: UITraitCollection?
    ) -> CGSize {
        let layout = typography.generateLayout(compatibleWith: traitCollection)
        let valueSize = self.size(withFont: layout.font)
        return CGSize(
            width: valueSize.width,
            height: max(valueSize.height, layout.lineHeight)
        )
    }

    private func size(withFont font: UIFont) -> CGSize {
        let scale = UIScreen.main.scale
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = size(withAttributes: fontAttributes)
        return CGSize(
            width: ceil(size.width * scale) / scale,
            height: ceil(size.height * scale) / scale
        )
    }
}
