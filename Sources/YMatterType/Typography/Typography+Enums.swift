//
//  Typography+Enums.swift
//  YMatterType
//
//  Created by Mark Pospesel on 5/2/22.
//

import UIKit

extension Typography {
    /// Font style (used together with font family name and font weight to load a specific font)
    public enum FontStyle: String, CaseIterable {
        /// Regular
        case regular = "normal"
        /// Italic
        case italic
    }

    /// The basic font weights. Not all fonts support every weight.
    ///
    /// The weight name to value mapping derives from [here](https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight#common_weight_name_mapping)
    public enum FontWeight: CGFloat, CaseIterable {
        /// Thin (Hairline) weight (100)
        case thin = 100
        /// Extra Light (Ultra Light) weight (200)
        case extraLight = 200
        /// Light weight (300)
        case light = 300
        /// Regular (Normal) weight (400)
        case regular = 400
        /// Medium weight (500)
        case medium = 500
        /// Semi Bold (Demi Bold) weight (600)
        case semibold = 600
        /// Bold weight (700)
        case bold = 700
        /// Extra Bold (Ultra Bold) weight (800)
        case extraBold = 800
        /// Black (Heavy) weight (900)
        case black = 900
        /// Extra Black (Ultra Black) weight (950)
        case extraBlack = 950

        /// Creates a new instance from a string.
        ///
        /// This will be useful for converting Figma tokens to `Typography` objects.
        /// Common synonyms will be accepted, e.g. both "SemiBold" and "DemiBold" map to `.semibold`.
        /// - Parameter weightName: the case-insensitive weight name, e.g. "Bold"
        public init?(_ weightName: String) {
            switch weightName.lowercased(with: Locale(identifier: "en_US")) {
            case "ultralight", "extralight":
                self = .extraLight
            case "thin":
                self = .thin
            case "light":
                self = .light
            case "regular", "normal":
                self = .regular
            case "medium":
                self = .medium
            case "semibold", "demibold":
                self = .semibold
            case "bold":
                self = .bold
            case "extrabold", "ultrabold":
                self = .extraBold
            case "heavy", "black":
                self = .black
            case "extrablack", "ultrablack":
                self = .extraBlack
            default:
                return nil
            }
        }
    }

    /// Capitalization to be applied to user-facing text
    public enum TextCase: String, CaseIterable {
        /// None (do not modify text)
        case none
        /// Lowercase
        case lowercase
        /// Uppercase (ALL CAPS)
        case uppercase
        /// Capitalize (also known as Title Case)
        case capitalize
    }

    /// Decoration to be applied
    public enum TextDecoration: String, CaseIterable {
        /// None
        case none
        /// Strikethrough
        case strikethrough = "line-through"
        /// Underline
        case underline
    }

    /// Line mode (single or multi)
    public enum LineMode {
        /// Single line
        case single
        /// Multi-line (use paragraph style)
        case multi(alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode?)
    }
}
