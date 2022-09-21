//
//  DefaultFontFamilyFactory.swift
//  YMatterType
//
//  Created by Mark Pospesel on 9/21/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation

/// Returns a `DefaultFontFamily` given a font family name and style.
public struct DefaultFontFamilyFactory {
    /// Initializes a default font family factory
    public init() { }
}

extension DefaultFontFamilyFactory: FontFamilyFactory {
    /// Given a family name and style instantiates and returns a `DefaultFontFamily`
    /// - Parameters:
    ///   - familyName: font family name
    ///   - style: font style
    /// - Returns: a font family matching the family name and style
    public func getFontFamily(familyName: String, style: Typography.FontStyle) -> FontFamily {
        DefaultFontFamily(familyName: familyName, style: style)
    }
}
