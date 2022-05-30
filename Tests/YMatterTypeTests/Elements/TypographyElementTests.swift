//
//  TypographyElementTests.swift
//  YMatterTypeTests
//
//  Created by Mark Pospesel on 5/25/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest

class TypographyElementTests: XCTestCase {
    /// Create nested view controllers containing the view to be tested so that we can override traits
    func makeNestedViewControllers(
        subview: UIView,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (parent: UIViewController, child: UIViewController) {
        let parent = UIViewController()
        let child = UIViewController()
        parent.addChild(child)
        parent.view.addSubview(child.view)

        // constrain child controller view to parent
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: parent.view.topAnchor).isActive = true
        child.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor).isActive = true

        child.view.addSubview(subview)

        // constrain subview to child view center
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: child.view.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: child.view.centerYAnchor).isActive = true

        trackForMemoryLeak(parent, file: file, line: line)
        trackForMemoryLeak(child, file: file, line: line)

        return (parent, child)
    }

    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }
}
