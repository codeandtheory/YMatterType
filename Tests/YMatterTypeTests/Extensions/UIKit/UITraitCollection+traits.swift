//
//  UITraitCollection+traits.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 3/19/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit

extension UITraitCollection {
    // MARK: - Fonts
    static let startingFontTraits = UITraitCollection(traitsFrom: [
        UITraitCollection(preferredContentSizeCategory: .large),
        UITraitCollection(legibilityWeight: .regular)
    ])

    // Traits affecting a variety of things but not Dynamic Type Size or Bold Text
    static func generateSimilarFontTraits(to startingTraits: UITraitCollection) -> [UITraitCollection] {
        // return each of these traits combined with startingTraits
        [
            UITraitCollection(horizontalSizeClass: .compact),
            UITraitCollection(verticalSizeClass: .compact),
            UITraitCollection(userInterfaceIdiom: .pad),
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(displayGamut: .P3),
            UITraitCollection(accessibilityContrast: .high),
            UITraitCollection(userInterfaceLevel: .elevated)
        ].map({ UITraitCollection(traitsFrom: [startingTraits, $0]) })
    }

    // Traits with different values for Dynamic Type Size or Bold Text
    static func generateDifferentFontTraits() -> [UITraitCollection] {
        [
            UITraitCollection(),
            UITraitCollection(traitsFrom: [
                UITraitCollection(preferredContentSizeCategory: .large),
                UITraitCollection(legibilityWeight: .bold)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(preferredContentSizeCategory: .extraLarge),
                UITraitCollection(legibilityWeight: .regular)
            ]),
            UITraitCollection(legibilityWeight: .unspecified),
            UITraitCollection(legibilityWeight: .bold),
            UITraitCollection(preferredContentSizeCategory: .unspecified),
            UITraitCollection(preferredContentSizeCategory: .extraSmall),
            UITraitCollection(preferredContentSizeCategory: .medium),
            UITraitCollection(preferredContentSizeCategory: .extraLarge),
            UITraitCollection(preferredContentSizeCategory: .extraExtraLarge),
            UITraitCollection(preferredContentSizeCategory: .extraExtraExtraLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityMedium),
            UITraitCollection(preferredContentSizeCategory: .accessibilityLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityExtraLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        ]
    }

    // MARK: - Color

    // Currently, a change in any of these traits could affect dynamic colors:
    // userInterfaceIdiom, userInterfaceStyle, displayGamut, accessibilityContrast, userInterfaceLevel
    // and more could be added in the future.

    static let startingColorTraits = UITraitCollection(traitsFrom: [
        UITraitCollection(userInterfaceIdiom: .phone),
        UITraitCollection(userInterfaceStyle: .light),
        UITraitCollection(displayGamut: .SRGB),
        UITraitCollection(accessibilityContrast: .normal),
        UITraitCollection(userInterfaceLevel: .base)
    ])

    // Traits affecting a variety of things but not anything that could change color appearance
    static func generateSimilarColorTraits(to startingTraits: UITraitCollection) -> [UITraitCollection] {
        // return each of these traits combined with startingTraits
        [
            UITraitCollection(horizontalSizeClass: .compact),
            UITraitCollection(verticalSizeClass: .compact),
            UITraitCollection(preferredContentSizeCategory: .accessibilityLarge),
            UITraitCollection(legibilityWeight: .bold)
        ].map({ UITraitCollection(traitsFrom: [startingTraits, $0]) })
    }

    // Traits with different values for traits that could affect color
    static func generateDifferentColorTraits() -> [UITraitCollection] {
        [
            UITraitCollection(),
            UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceIdiom: .pad),
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(displayGamut: .SRGB),
                UITraitCollection(accessibilityContrast: .normal),
                UITraitCollection(userInterfaceLevel: .base)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceIdiom: .phone),
                UITraitCollection(userInterfaceStyle: .dark),
                UITraitCollection(displayGamut: .SRGB),
                UITraitCollection(accessibilityContrast: .normal),
                UITraitCollection(userInterfaceLevel: .base)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceIdiom: .phone),
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(displayGamut: .P3),
                UITraitCollection(accessibilityContrast: .normal),
                UITraitCollection(userInterfaceLevel: .base)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceIdiom: .phone),
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(displayGamut: .SRGB),
                UITraitCollection(accessibilityContrast: .high),
                UITraitCollection(userInterfaceLevel: .base)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceIdiom: .phone),
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(displayGamut: .SRGB),
                UITraitCollection(accessibilityContrast: .normal),
                UITraitCollection(userInterfaceLevel: .elevated)
            ]),
            UITraitCollection(userInterfaceIdiom: .tv),
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(displayGamut: .P3),
            UITraitCollection(accessibilityContrast: .high),
            UITraitCollection(userInterfaceLevel: .elevated)
        ]
    }

    // MARK: - Breakpoints

    static let startingBreakpointTraits = UITraitCollection(traitsFrom: [
        UITraitCollection(horizontalSizeClass: .compact),
        UITraitCollection(verticalSizeClass: .regular)
    ])

    // Traits affecting a variety of things but not horizontal or vertical size class
    static func generateSimilarBreakpointTraits(to startingTraits: UITraitCollection) -> [UITraitCollection] {
        // return each of these traits combined with startingTraits
        [
            UITraitCollection(preferredContentSizeCategory: .accessibilityMedium),
            UITraitCollection(legibilityWeight: .bold),
            UITraitCollection(userInterfaceIdiom: .pad),
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(displayGamut: .P3),
            UITraitCollection(accessibilityContrast: .high),
            UITraitCollection(userInterfaceLevel: .elevated)
        ].map({ UITraitCollection(traitsFrom: [startingTraits, $0]) })
    }

    // Traits with different values for traits that could affect breakpoints
    static func generateDifferentBreakpointTraits() -> [UITraitCollection] {
        [
            UITraitCollection(),
            UITraitCollection(traitsFrom: [
                UITraitCollection(horizontalSizeClass: .compact),
                UITraitCollection(verticalSizeClass: .compact)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact)
            ]),
            UITraitCollection(traitsFrom: [
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .regular)
            ]),
            UITraitCollection(horizontalSizeClass: .regular),
            UITraitCollection(horizontalSizeClass: .compact),
            UITraitCollection(horizontalSizeClass: .unspecified),
            UITraitCollection(verticalSizeClass: .regular),
            UITraitCollection(verticalSizeClass: .compact),
            UITraitCollection(verticalSizeClass: .unspecified)
        ]
    }
}
