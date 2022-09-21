//
//  FontFamilyFactory.swift
//  YMatterType
//
//  Created by Mark Pospesel on 9/21/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation

/// Returns a font family given a font family name and style.
public protocol FontFamilyFactory {
    /// Given a family name and style returns a font family
    /// - Parameters:
    ///   - familyName: font family name
    ///   - style: font style
    /// - Returns: a font family matching the family name and style
    func getFontFamily(familyName: String, style: Typography.FontStyle) -> FontFamily
}
