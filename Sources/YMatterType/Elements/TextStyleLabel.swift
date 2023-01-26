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
    let text: String
    
    /// Typography to be used for this label's text
    let typography: Typography
    
    /// A closure that gets called on the init and refresh of the View
    /// This closure allows you to provide additional configuration to the `TypographyLabel`
    let configureTextStyleLabel: ((TypographyLabel) -> Void)?

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

extension TextStyleLabel {
    /// A wrapper for a UIKit TypographyLabel view that allows to integrate that view into a SwiftUI view hierarchy.
    struct TypographyLabelRepresentable: UIViewRepresentable {
        /// The type of view to present.
        typealias UIViewType = TypographyLabel

        /// The text that the label displays.
        let text: String
        
        /// Typography to be used for this label's text
        let typography: Typography
        
        /// A closure that gets called on the init and refresh of the View
        let configureTextStyleLabel: ((TypographyLabel) -> Void)?

        /// Creates the view object and configures its initial state.
        ///
        /// - Parameter context: A context structure containing information about
        ///   the current state of the system.
        ///
        /// - Returns: `TypographyLabel` view configured with the provided information.
        func makeUIView(context: Context) -> TypographyLabel {
            let label = TypographyLabel(typography: typography)
            label.text = text
            
            label.numberOfLines = 1

            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            configureTextStyleLabel?(label)
            return label
        }
        
        /// Updates the state of the specified view with new information from
        /// SwiftUI.
        ///
        /// - Parameters:
        ///   - uiView: `TypographyLabel` view.
        ///   - context: A context structure containing information about the current
        ///     state of the system.
        func updateUIView(_ uiView: TypographyLabel, context: Context) {
            uiView.typography = typography
            uiView.text = text
            configureTextStyleLabel?(uiView)
        }
    }
}
