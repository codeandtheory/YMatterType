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
    var systemWeight: UIFont.Weight {
        switch self {
        case .ultralight:
            return .ultraLight
        case .thin:
            return .thin
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
        case .heavy:
            return .heavy
        case .black:
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
        // The system font cannot be retrieved using UIFont.font(name:size:), but
        // instead must be created using UIFont.systemFont(ofSize:weight:)
        let useBoldFont = isBoldTextEnabled(compatibleWith: traitCollection)
        let actualWeight = useBoldFont ? accessibilityBoldWeight(for: weight) : weight

        return UIFont.systemFont(ofSize: pointSize, weight: actualWeight.systemWeight)
    }
}
