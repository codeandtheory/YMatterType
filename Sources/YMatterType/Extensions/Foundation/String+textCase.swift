//
//  String+textCase.swift
//  YMatterType
//
//  Created by Mark Pospesel on 5/2/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import Foundation

extension String {
    /// Applies a text case to the string.
    /// - Parameter textCase: the text case to apply
    /// - Returns: the updated string
    public func textCase(_ textCase: Typography.TextCase) -> String {
        switch textCase {
        case .none:
            return self
        case .lowercase:
            return localizedLowercase
        case .uppercase:
            return localizedUppercase
        case .capitalize:
            return localizedCapitalized
        }
    }
}
