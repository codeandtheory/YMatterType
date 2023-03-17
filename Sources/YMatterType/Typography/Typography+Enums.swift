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

    /// The nine basic font weights. Not all fonts support all 9 weights.
    public enum FontWeight: CGFloat, CaseIterable {
        /// ultralight (aka extra light) weight (100)
        case ultralight = 100
        /// thin weight (200)
        case thin = 200
        /// light weight (300)
        case light = 300
        /// regular weight (400)
        case regular = 400
        /// medium weight (500)
        case medium = 500
        /// semibold weight (600)
        case semibold = 600
        /// bold weight (700)
        case bold = 700
        /// heavy (aka extra bold) weight (800)
        case heavy = 800
        /// black weight (900)
        case black = 900

        /// Creates a new instance from a string.
        ///
        /// This will be useful for converting Figma tokens to `Typography` objects.
        /// Common synonyms will be accepted, e.g. both "SemiBold" and "DemiBold" map to `.semibold`.
        /// - Parameter weightName: the case-insensitive weight name, e.g. "Bold"
        init?(_ weightName: String) {
            switch weightName.lowercased(with: Locale(identifier: "en_US")) {
            case "ultralight", "extralight":
                self = .ultralight
            case "thin":
                self = .thin
            case "light":
                self = .light
            case "regular":
                self = .regular
            case "medium":
                self = .medium
            case "semibold", "demibold":
                self = .semibold
            case "bold":
                self = .bold
            case "heavy", "extrabold", "ultrabold":
                self = .heavy
            case "black":
                self = .black
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
