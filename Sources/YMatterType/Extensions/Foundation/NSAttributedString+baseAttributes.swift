//
//  NSAttributedString+baseAttributes.swift
//  YMatterType
//
//  Created by Mark Pospesel on 3/2/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation

extension NSAttributedString {
    /// Returns an attributed string consisting of the attributed string's text with the specified attributes applied
    /// to the entire range and then the attributed string's attributes copied on top of that.
    /// - Parameter baseAttributes: the attributes to apply to the entire range
    /// - Returns: An attributed string with the universal attributes applied beneath the attributed string's
    /// own attributes
    public func attributedString(with baseAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        // First we create a new attributed string from the plain text and the base attributes
        let updated = NSMutableAttributedString(string: string, attributes: baseAttributes)

        // Then we iterate through all the attributes and apply them to `updated`
        let rangeAll = NSRange(location: 0, length: length)
        enumerateAttributes(
            in: rangeAll,
            options: []
        ) { attributes, range, _ in
            // But we don't wish to reapply our base attributes
            if range != rangeAll || attributes.keys != baseAttributes.keys {
                updated.addAttributes(attributes, range: range)
            }
        }

        return updated
    }
}
