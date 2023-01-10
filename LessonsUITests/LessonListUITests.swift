//
//  LessonListUITests.swift
//  LessonsUITests
//
//  Created by Mayur Shrivas on 10/01/23.
//

import XCTest

final class LessonListUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        launchApp()
    }
    
    func testListContent() throws {
        waitForPage("Lessons")
    }
}
