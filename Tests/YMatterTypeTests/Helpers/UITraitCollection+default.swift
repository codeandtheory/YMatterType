//
//  UITraitCollection+default.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 4/26/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit

extension UITraitCollection {
    static var `default` = UITraitCollection(traitsFrom: [
        UITraitCollection(preferredContentSizeCategory: .large),
        UITraitCollection(legibilityWeight: .regular)
    ])
}
