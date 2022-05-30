//
//  UIFont+load.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/24/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType

extension UIFont {
    static func register(name: String) throws {
        try UIFont.register(name: name, fileExtension: "otf", subpath: "Assets/Fonts", bundle: .module)
    }

    static func unregister(name: String) throws {
        try UIFont.unregister(name: name, fileExtension: "otf", subpath: "Assets/Fonts", bundle: .module)
    }
}
