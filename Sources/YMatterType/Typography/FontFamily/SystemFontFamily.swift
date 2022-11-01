//
//  SystemFontFamily.swift
//  YMatterType
//
//  Created by Mark Pospesel on 9/28/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

public extension Typography.FontWeight {
    /// Conversion from FontWeight enum to UIFont.Weight struct
    ///
    /// While they adopt similar names, they do not map 1:1
    var systemWeight: UIFont.Weight {
        switch self {
        case .extraLight:
            return .thin
        case .thin:
            return .ultraLight
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .black, .extraBlack:
            return .black
        }
    }
}

public extension Typography {
    /// Information about the system font family
    static let systemFamily: FontFamily = SystemFontFamily()
}

extension DefaultFontFamily {
    /// Information about the system font family
    ///
    /// Renamed to `Typography.systemFamily`
    @available(*, deprecated, renamed: "Typography.systemFamily")
    static var system: FontFamily { Typography.systemFamily }
}

/// Information about the system font. System font implementation of FontFamily.
public struct SystemFontFamily: FontFamily {
    // The system font has a private font family name (literally ".SFUI"), so
    // just return empty string for familyName. The system font can't be retrieved by name anyway.
    public var familyName: String { "" }

    /// Returns a font for the specified `weight` and `pointSize` that is compatible with the `traitCollection`
    /// - Parameters:
    ///   - weight: desired font weight
    ///   - pointSize: desired font point size
    ///   - traitCollection: trait collection to consider (`UITraitCollection.legibilityWeight`).
    /// If `nil` then `UIAccessibility.isBoldTextEnabled` will be considered instead
    public func font(
        for weight: Typography.FontWeight,
        pointSize: CGFloat,
        compatibleWith traitCollection: UITraitCollection?
    ) -> UIFont {
        // When UIAccessibility.isBoldTextEnabled == true, then we don't need to manually
        // adjust the weight because the system will do it for us.
        let useBoldFont = isBoldTextEnabled(compatibleWith: traitCollection) && !UIAccessibility.isBoldTextEnabled
        let actualWeight = useBoldFont ? accessibilityBoldWeight(for: weight) : weight

        // The system font cannot be retrieved using UIFont.font(name:size:), but
        // instead must be created using UIFont.systemFont(ofSize:weight:)
        return UIFont.systemFont(ofSize: pointSize, weight: actualWeight.systemWeight)
    }

    /// Returns the next heavier supported weight (if any), otherwise the heaviest supported weight
    public func accessibilityBoldWeight(for weight: Typography.FontWeight) -> Typography.FontWeight {
        var boldWeight: Typography.FontWeight

        switch weight {
        // For 3 lightest weights, move up 1 weight
        case .thin:
            boldWeight = .extraLight
        case .extraLight:
            boldWeight = .light
        case .light:
            boldWeight = .regular

        // For all remaining weights, move up 2 weights
        case .regular:
            boldWeight = .semibold
        case .medium:
            boldWeight = .bold
        case .semibold:
            boldWeight = .extraBold
        case .bold, .extraBold, .black, .extraBlack:
            boldWeight = .black
        }

        return boldWeight
    }
}
