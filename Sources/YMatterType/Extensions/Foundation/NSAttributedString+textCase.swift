//
//  NSAttributedString+textCase.swift
//  YMatterType
//
//  Created by Mark Pospesel on 5/3/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation

extension NSAttributedString {
    /// Applies a text case to an attributed string.
    ///
    /// Applying `capitalized` (Title Case) may be problematic because it is applied in fragments
    /// according to the attributes. So "John" could become "JoHn" if an attribute were applied only to
    /// first two or last two letters. But we have to do it this way because capitalization operations are not
    /// guaranteed to be symmetrical. e.g. "straße".uppercased() == "STRASSE".
    /// - Parameter textCase: the text case to apply
    /// - Returns: the updated attributed string
    public func textCase(_ textCase: Typography.TextCase) -> NSAttributedString {
        guard textCase != .none else { return self }

        let modified = NSMutableAttributedString(attributedString: self)

        modified.enumerateAttributes(in: NSRange(location: 0, length: length), options: []) { _, range, _ in
            modified.replaceCharacters(
                in: range,
                with: (string as NSString).substring(with: range).textCase(textCase)
            )
        }

        return modified
    }
}
