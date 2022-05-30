//
//  XCTestCase+MemoryLeakTracking.swift
//  YCoreUITests
//
//  Created by Karthik K Manoj on 08/04/22.
//  Copyright © 2022 Y Media Labs. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
