//
//  UITraitCollection+fontAppearance.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/12/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

extension UITraitCollection {
    /// Return whether this trait collection, compared to a different trait collection,
    /// could show a different appearance for fonts.
    ///
    /// If you need to be aware of when fonts might change, override
    /// `traitCollectionDidChange` in your view or view controller, and use this
    /// method to compare `self.traitCollection` with `previousTraitCollection`.
    ///
    /// Currently, a change in any of these traits could affect fonts:
    /// preferredContentSizeCategory, legibilityWeight
    /// and more could be added in the future.
    /// - Parameter traitCollection: A trait collection that you want to compare to the current trait collection.
    /// - Returns: Returns a Boolean value indicating whether changing between the
    /// specified and current trait collections would affect fonts.
    public func hasDifferentFontAppearance(comparedTo traitCollection: UITraitCollection?) -> Bool {
        preferredContentSizeCategory != traitCollection?.preferredContentSizeCategory ||
            legibilityWeight != traitCollection?.legibilityWeight
    }
}
