//
//  UITraitCollection+breakpoint.swift
//  YMatterType
//
//  Created by Mark Pospesel on 3/18/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit

extension UITraitCollection {
    /// Return whether this trait collection, compared to a different trait collection,
    /// could represent a different breakpoint.
    ///
    /// Breakpoints are design specific, but a common one is at 600 points. Ideally looking at window size
    /// would be the way to detect every breakpoint change.
    ///
    /// If you need to be aware of when breakpoints might change, override
    /// `traitCollectionDidChange` in your view or view controller, and use this
    /// method to compare `self.traitCollection` with `previousTraitCollection`.
    ///
    /// Currently, a change in any of these traits could affect breakpoints:
    /// horizontalSizeClass, verticalSizeClass
    /// and more could be added in the future.
    /// - Parameter traitCollection: A trait collection that you want to compare to the current trait collection.
    /// - Returns: Returns a Boolean value indicating whether changing between the
    /// specified and current trait collections could affect breakpoints.
    public func hasDifferentBreakpoint(comparedTo traitCollection: UITraitCollection?) -> Bool {
        horizontalSizeClass != traitCollection?.horizontalSizeClass ||
            verticalSizeClass != traitCollection?.verticalSizeClass
    }
}
