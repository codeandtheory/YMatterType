//
//  TextStyleLabelTests.swift
//  TextStyleLabelTests
//
//  Created by Virginia Pujols on 1/24/23.
//

import XCTest
import SwiftUI
import ViewInspector
import YMatterType
@testable import Playground

final class TextStyleLabelTests: XCTestCase {
    private struct TextConstants {
        static let helloWorld = "Hello, world!"
    }

    func testInspectorBaseline() throws {
        let expected = TextConstants.helloWorld
        
        let sut = Text(expected)
        
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    func testContentViewTextValue() throws {
        let view = ContentView()
        
        let expected = TextConstants.helloWorld
        let sut = try view.inspect().find(text: expected)
        
        let value = try sut.string()
        XCTAssertEqual(value, expected)
    }
    
    func testTextStyleLabelSingleLine() throws {
        let view = TextStyleLabelView()
        ViewHosting.host(view: view)

        let textContainer = try view.inspect().find(TextStyleLabel.self)
        let sut = try textContainer.find(TextStyleLabel.TypographyLabelRepresentable.self).actualView().uiView()

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.font.pointSize, view.typograpy.fontSize)
        XCTAssertEqual(sut.intrinsicContentSize.height, sut.typography.lineHeight)
        XCTAssertEqual(sut.lineBreakMode, .byTruncatingMiddle)
        XCTAssertEqual(sut.numberOfLines, 1)
        XCTAssertEqual(sut.text, view.displayText)
    }
}
