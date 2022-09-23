//
//  UIFont+registerTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/25/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YMatterType

final class UIFontRegisterTests: XCTestCase {
    func testRegisterUnregister() throws {
        try UIFont.register(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        try UIFont.unregister(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
    }

    func testRegisterFailure() {
        _testRegisterFailure(name: "Not-A-Font-File", fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        _testRegisterFailure(name: fileName, fileExtension: "badext", subpath: subpath, bundle: bundle)
        _testRegisterFailure(name: fileName, fileExtension: fileExtension, subpath: "Bad/Path", bundle: bundle)
        _testRegisterFailure(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: .main)
    }

    func testRegisterTwice() throws {
        // Given a registered font
        try UIFont.register(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        // We expect second call to fail because font is already registered
        _testRegisterFailure(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)

        // Clean up
        try UIFont.unregister(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
    }

    func testUnregisterFailure() {
        _testUnregisterFailure(name: "Not-A-Font-File", fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        _testUnregisterFailure(name: fileName, fileExtension: "badext", subpath: subpath, bundle: bundle)
        _testUnregisterFailure(name: fileName, fileExtension: fileExtension, subpath: "Bad/Path", bundle: bundle)
        _testUnregisterFailure(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: .main)
    }

    func testUnregisterTwice() throws {
        // We expect initial call to fail because font was never registered
        _testUnregisterFailure(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)

        // Given a registered font
        try UIFont.register(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        // that is then unregistered
        try UIFont.unregister(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
        // We expect second call to fail because font is already unregistered
        _testUnregisterFailure(name: fileName, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
    }
}

private extension UIFontRegisterTests {
    var fileName: String { "NotoSans-Regular" }
    var fileExtension: String { "ttf" }
    var subpath: String { "Assets/Fonts" }
    var bundle: Bundle { .module }

    func _testRegisterFailure(name: String, fileExtension: String?, subpath: String?, bundle: Bundle) {
        do {
            try UIFont.register(name: name, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
            XCTFail("Expected register to throw")
        } catch {
            // We expect an error
        }
    }

    func _testUnregisterFailure(name: String, fileExtension: String?, subpath: String?, bundle: Bundle) {
        do {
            try UIFont.unregister(name: name, fileExtension: fileExtension, subpath: subpath, bundle: bundle)
            XCTFail("Expected unregister to throw")
        } catch {
            // We expect an error
        }
    }
}
