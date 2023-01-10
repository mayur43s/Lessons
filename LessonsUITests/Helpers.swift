//
//  Helpers.swift
//  LessonsUITests
//
//  Created by Mayur Shrivas on 10/01/23.
//

import XCTest

extension XCTestCase {
    //MARK: - Helper functions -
    
    func waitFor(_ element: XCUIElement, timeout: TimeInterval = 10) {
        _ = element.waitForExistence(timeout: timeout)
    }
    
    func waitForPage(_ navBarTitle: String) {
        let e = XCUIApplication().navigationBars[navBarTitle]
        waitFor(e)
    }
    
    func launchApp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = ["UITest": "true"]
        app.launch()
    }
    
    func XCAssertStaticTextExists(text: String) {
        let label = XCUIApplication().staticTexts[text]
        waitFor(label)
        XCTAssertTrue(label.exists)
    }
}
