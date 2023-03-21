//
//  TypographyLabelRepresentable.swift
//  YMatterType
//
//  Created by Virginia Pujols on 1/27/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import SwiftUI

/// A wrapper for a UIKit TypographyLabel view that allows to integrate that view into a SwiftUI view hierarchy.
struct TypographyLabelRepresentable {
    /// The type of view to present.
    typealias UIViewType = TypographyLabel

    /// The text that the label displays.
    var text: String
    
    /// Typography to be used for this label's text
    var typography: Typography
    
    /// A closure that gets called on the init and refresh of the View
    var configureTextStyleLabel: ((TypographyLabel) -> Void)?
}

extension TypographyLabelRepresentable: UIViewRepresentable {
    /// Creates the view object and configures its initial state.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: `TypographyLabel` view configured with the provided information.
    func makeUIView(context: Context) -> TypographyLabel {
        getLabel()
    }

    func getLabel() -> TypographyLabel {
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
        updateLabel(uiView)
    }

    func updateLabel(_ label: TypographyLabel) {
        label.typography = typography
        label.text = text
        configureTextStyleLabel?(label)
    }
}
