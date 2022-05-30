//
//  UIFont+register.swift
//  YMatterType
//
//  Created by Mark Pospesel on 5/25/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import UIKit

extension UIFont {
    /// Error registering or unregistering a font
    public enum RegisterError: Error {
        /// URL to the font file could not be created. Check the file name, extension, subpath, and bundle.
        case urlNotFound
    }

    /// Registers a font file with the system Font Manager.
    /// - Parameters:
    ///   - name: font file name (may also include subpath or extension)
    ///   - ext: (optional) font file extension (e.g. "otf" or "ttf") if not already included in `name`
    ///   - subpath: (optional) subpath to the font file within the bundle if not already included in `name`
    ///   - bundle: bundle containing the font file
    /// - Throws: an error if the file cannot be registered (including if it is already registered).
    public static func register(
        name: String,
        fileExtension ext: String? = nil,
        subpath: String? = nil,
        bundle: Bundle
    ) throws {
        guard let fontURL = bundle.url(
            forResource: name,
            withExtension: ext,
            subdirectory: subpath
        ) else {
            throw RegisterError.urlNotFound
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, &error)
        if let error = error?.takeUnretainedValue() as? Error {
            throw error
        }
    }

    /// Unregisters a font file with the system Font Manager.
    ///
    /// Should be paired with succcessful call to `register(:)`
    /// - Parameters:
    ///   - name: font file name (may also include subpath or extension)
    ///   - ext: (optional) font file extension (e.g. "otf" or "ttf") if not already included in `name`
    ///   - subpath: (optional) subpath to the font file within the bundle if not already included in `name`
    ///   - bundle: bundle containing the font file
    /// - Throws: an error if the file cannot be unregistered (including if it was never registered or
    /// has already been successfully unregistered).
    public static func unregister(
        name: String,
        fileExtension ext: String? = nil,
        subpath: String? = nil,
        bundle: Bundle
    ) throws {
        guard let fontURL = bundle.url(
            forResource: name,
            withExtension: ext,
            subdirectory: subpath
        ) else {
            throw RegisterError.urlNotFound
        }

        var error: Unmanaged<CFError>?
        CTFontManagerUnregisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, &error)
        if let error = error?.takeUnretainedValue() as? Error {
            throw error
        }
    }
}
