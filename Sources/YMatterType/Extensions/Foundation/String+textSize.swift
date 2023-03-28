//
//  String+textSize.swift
//  YMatterType
//
//  Created by Sahil Saini on 27/03/23.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit

extension String {
    /// Calculates the size of the string rendered with the specified typography.
    /// - Parameters:
    ///   - typography: the typography to be used to calculate the string size
    ///   - traitCollection: the trait collection to apply
    /// - Returns: the size of the string
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

    /// Calculates the size of the string rendered with the specified font.
    ///
    /// The returned size will be rounded up to the nearest pixel in both width and height.
    /// - Parameters:
    ///   - font: the font to be used to calculate the string size
    ///   - traitCollection: the trait collection to apply (used for `displayScale`)
    /// - Returns: the size of the string
    public func size(
        withFont font: UIFont,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> CGSize {
        let scale: CGFloat
        if let displayScale = traitCollection?.displayScale,
           displayScale != 0.0 {
            scale = displayScale
        } else {
            scale = UIScreen.main.scale
        }
        
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = size(withAttributes: fontAttributes)
        return CGSize(
            width: ceil(size.width * scale) / scale,
            height: ceil(size.height * scale) / scale
        )
    }
}
