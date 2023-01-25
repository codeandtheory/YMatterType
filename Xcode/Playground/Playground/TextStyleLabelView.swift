//
//  TextStyleLabelView.swift
//  Playground
//
//  Created by Virginia Pujols on 1/24/23.
//

import SwiftUI
import YMatterType

struct TextStyleLabelView: View {
    
    var typograpy: Typography = .systemLabel.fontSize(28).lineHeight(43)
    var lineBreakMode: NSLineBreakMode = .byTruncatingMiddle
    var displayText = "This is a long text that will be truncated"

    var body: some View {
        VStack(alignment: .leading) {
            TextStyleLabel(displayText,
                           typography: typograpy, configuration: { label in
                label.lineBreakMode = lineBreakMode
            })
            .background(Color.yellow.opacity(0.5))
        }
        .padding()
    }
}

struct TextStyleLabelView_Previews: PreviewProvider {
    static var previews: some View {
        TextStyleLabelView()
    }
}
