//
//  FontFamily.swift
//  YMatterType
//
//  Created by Mark Pospesel on 8/23/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit
import os

/// Information about a font family. When an app specifies a custom font, they will
/// implement an instance of FontFamily to fully describe that font.
public protocol FontFamily {
    /// Font family root name, e.g. "AvenirNext"
    var familyName: String { get }

    /// Optional suffix to use for the font name.
    ///
    /// Used by `FontFamily.fontName(for:compatibleWith:)`
    /// e.g. "Italic" is a typical suffix for italic fonts.
    /// default = ""
    var fontNameSuffix: String { get }

    /// All font weights supported by this font family (or those that you choose to bundle in your project).
    ///
    /// Defaults to 9 basic font weights, but can be overridden in custom implementations of `FontFamily`.
    /// You must support at least one weight.
    /// This is used in the default implementation of `accessibilityBoldWeight(for:)`
    var supportedWeights: [Typography.FontWeight] { get }

    // The following four methods have default implementations that
    // can be overridden in custom implementations of `FontFamily`.

    /// Returns a font for the specified `weight` and `pointSize` that is compatible with the `traitCollection`
    /// - Parameters:
    ///   - weight: desired font weight
    ///   - pointSize: desired font point size
    ///   - traitCollection: trait collection to consider (`UITraitCollection.legibilityWeight`).
    /// If `nil` then `UIAccessibility.isBoldTextEnabled` will be considered instead
    func font(
        for weight: Typography.FontWeight,
        pointSize: CGFloat,
        compatibleWith traitCollection: UITraitCollection?
    ) -> UIFont

    /// Generates a font name that can be used to initialize a `UIFont`. Not all fonts support all font weights.
    /// - Parameter weight: desired font weight
    /// - Parameter traitCollection: trait collection to consider (`UITraitCollection.legibilityWeight`).
    /// If `nil` then `UIAccessibility.isBoldTextEnabled` will be considered instead
    /// - Returns: The font name formulated from `familyName` and `weight`
    func fontName(for weight: Typography.FontWeight, compatibleWith traitCollection: UITraitCollection?) -> String

    /// Generates a weight name suffix as part of a full font name. Not all fonts support all font weights.
    /// - Parameter weight: desired font weight
    /// - Returns: The weight name to use
    func weightName(for weight: Typography.FontWeight) -> String

    /// Returns the alternate weight to use if user has requested a bold font. e.g. might convert `.regular`
    /// to `.semibold`. Not all fonts support all font weights.
    /// - Parameter weight: desired font weight
    /// - Returns: the alternate weight to use if user has requested a bold font.
    /// Should be heavier than weight if possible.
    func accessibilityBoldWeight(for weight: Typography.FontWeight) -> Typography.FontWeight
}

extension Typography {
    fileprivate static let logger = Logger(subsystem: "YMatterType", category: "fonts")
}

// MARK: - Default implementations

/// Default implementations
extension FontFamily {
    /// Returns no suffix
    public var fontNameSuffix: String { "" }

    // Returns all weights except `.extraBlack`
    public var supportedWeights: [Typography.FontWeight] {
        [.thin, .extraLight, .light, .regular, .medium, .semibold, .bold, .extraBold, .black]
    }

    /// Generates the font to be used using `UIFont(name:size:)` and the name generated by
    /// `fontName(weight:traitCollection:)`
    public func font(
        for weight: Typography.FontWeight,
        pointSize: CGFloat,
        compatibleWith traitCollection: UITraitCollection?
    ) -> UIFont {
        let name = fontName(for: weight, compatibleWith: traitCollection)
        guard let font = UIFont(name: name, size: pointSize) else {
            // Fallback to system font and log a message.
            Typography.logger.warning("Custom font \(name) not properly installed.")
            return Typography.systemFamily.font(
                for: weight,
                pointSize: pointSize,
                compatibleWith: traitCollection
            )
        }
        return font
    }

    /// Generates the font name by combining family name, the weight name
    /// (potentially adjusted for Bold Text), and suffix.
    public func fontName(
        for weight: Typography.FontWeight,
        compatibleWith traitCollection: UITraitCollection?
    ) -> String {
        // Default font name formulation accounting for Accessibility Bold setting
        let useBoldFont = isBoldTextEnabled(compatibleWith: traitCollection)
        let actualWeight = useBoldFont ? accessibilityBoldWeight(for: weight) : weight
        let weightName = weightName(for: actualWeight)
        let suffix = fontNameSuffix
        if weightName.isEmpty && suffix.isEmpty {
            // don't use "-" if nothing will follow it
            return familyName
        }
        return "\(familyName)-\(weightName)\(suffix)"
    }

    /// Returns default name for each weight
    public func weightName(for weight: Typography.FontWeight) -> String {
        // Default font name suffix by weight
        switch weight {
        case .extraLight:
            return "ExtraLight"
        case .thin:
            return "Thin"
        case .light:
            return "Light"
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "SemiBold"
        case .bold:
            return "Bold"
        case .extraBold:
            return "ExtraBold"
        case .black:
            return "Black"
        case .extraBlack:
            return "ExtraBlack"
        }
    }

    /// Returns the next heavier supported weight (if any), otherwise the heaviest supported weight.
    public func accessibilityBoldWeight(for weight: Typography.FontWeight) -> Typography.FontWeight {
        let weights = supportedWeights.sorted(by: { $0.rawValue < $1.rawValue })
        // return the next heavier supported weight
        return weights.first(where: { $0.rawValue > weight.rawValue }) ?? weights.last ?? weight
    }

    /// Determines whether the accessibility Bold Text feature is enabled within the given trait collection.
    /// - Parameter traitCollection: the trait collection to evaluate (or nil to use system settings)
    /// - Returns: `true` if the accessibility Bold Text feature is enabled.
    ///
    /// If `traitCollection` is not `nil`, it checks for `legibilityWeight == .bold`.
    /// If `traitCollection` is `nil`, then it examines the system wide `UIAccessibility` setting of the same name.
    public func isBoldTextEnabled(compatibleWith traitCollection: UITraitCollection?) -> Bool {
        guard let traitCollection = traitCollection else {
            return UIAccessibility.isBoldTextEnabled
        }

        return traitCollection.legibilityWeight == .bold
    }
}
