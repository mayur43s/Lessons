//
//  LessonDetailsUITests.swift
//  LessonsUITests
//
//  Created by Mayur Shrivas on 10/01/23.
//

import XCTest

final class LessonDetailsUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        launchApp()
    }
    
    func testLessonDetailsContent() throws {
        waitForPage("Lessons")
        let app = XCUIApplication()
        app.tap()
        XCAssertStaticTextExists(text: "3 Secret iPhone Camera Features For Perfect Focus")
    }
    
    func testDownload() throws {
        let app = XCUIApplication()
        app.tap()
        
        let downloadButton = app.buttons["Download"]
        waitFor(downloadButton, timeout: 30)
        downloadButton.tap()
    }
}
