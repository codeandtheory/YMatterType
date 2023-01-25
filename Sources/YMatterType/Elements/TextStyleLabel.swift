//
//  TextStyleLabel.swift
//  YMatterType
//
//  Created by Virginia Pujols on 1/11/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import SwiftUI

public struct TextStyleLabel: View {
    private let text: String
    private let typography: Typography
    private let configureTypographyText: ((TypographyLabel) -> Void)?

    public init(_ text: String,
                typography: Typography,
                configuration: ((TypographyLabel) -> Void)? = nil) {
        self.typography = typography
        self.text = text
        self.configureTypographyText = configuration
    }

    public var body: some View {
        TypographyLabelRepresentable(text,
                                     typography: typography,
                                     configuration: configureTypographyText)
            .fixedSize(horizontal: false, vertical: true)
    }
}

public extension TextStyleLabel {
    struct TypographyLabelRepresentable: UIViewRepresentable {
        public typealias UIViewType = TypographyLabel

        private let typography: Typography
        private let text: String
        private let configureText: ((TypographyLabel) -> Void)?

        public init(_ text: String,
                    typography: Typography,
                    configuration: ((TypographyLabel) -> Void)? = nil) {
            self.typography = typography
            self.text = text
            self.configureText = configuration
        }
        
        public func makeUIView(context: Context) -> TypographyLabel {
            let label = TypographyLabel(typography: typography)
            label.text = text
            
            label.numberOfLines = 1

            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            configureText?(label)
            return label
        }
        
        public func updateUIView(_ uiView: TypographyLabel, context: Context) {
            uiView.typography = typography
            uiView.text = text
            configureText?(uiView)
        }
    }
}
