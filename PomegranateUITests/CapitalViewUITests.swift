//
//  CapitalViewUITests.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2023-07-18.
//

import XCTest

final class POM_UITestingUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchEnvironment["uitesting.launchScreen"] = "CapitalView"

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testElementExistance() throws {
        app.launch()

        CapitalView(app)
            .assertExists(.flag)?
            .assertExists(.name)?
            .assertExists(.country)?
            .assertExists(.textEntry("Beijing"))?
            .assertExists(.textEntry("China"))?
            .assertExists(.population("21,542,000"))?
            .assertExists(.percentagePop(1.50))
    }
    
    // For more concrete examples of how the DSL looks like. See the CapitalTableView tests.
}
