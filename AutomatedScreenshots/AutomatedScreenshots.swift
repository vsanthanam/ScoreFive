//
//  AutomatedScreenshots.swift
//  AutomatedScreenshots
//
//  Created by Varun Santhanam on 7/31/22.
//

import XCTest

class AutomatedScreenshots: XCTestCase {

    func test_launch() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("a-home")
    }
    
    func test_settings() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        XCUIApplication().buttons["More"].tap()
        snapshot("c-settings")
    }
    
}
