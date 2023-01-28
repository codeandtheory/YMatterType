//
//  TextStyleLabel.swift
//  YMatterType
//
//  Created by Virginia Pujols on 1/11/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import SwiftUI

/// A singe line text label that supports `Typography` for SwiftUI.
public struct TextStyleLabel: View {
    /// The text that the label displays.
    var text: String
    
    /// Typography to be used for this label's text
    var typography: Typography
    
    /// A closure that gets called on the init and refresh of the View
    /// This closure allows you to provide additional configuration to the `TypographyLabel`
    var configureTextStyleLabel: ((TypographyLabel) -> Void)?

    /// The content and behavior of the view.
    public var body: some View {
        TypographyLabelRepresentable(
            text: text,
            typography: typography,
            configureTextStyleLabel: configureTextStyleLabel
        )
        .fixedSize(horizontal: false, vertical: true)
    }

    /// Initializes a `TextStyleLabel` instance with the specified parameters
    /// - Parameters:
    ///   - text: The text that the label displays
    ///   - typography: Typography to be used for this label's text
    ///   - configuration: A closure that gets called on the init and refresh of the View
    public init(
        _ text: String,
        typography: Typography,
        configuration: ((TypographyLabel) -> Void)? = nil
    ) {
        self.typography = typography
        self.text = text
        self.configureTextStyleLabel = configuration
    }
}
