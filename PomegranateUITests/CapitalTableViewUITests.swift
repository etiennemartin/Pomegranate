//
//  CapitalTableViewUITests.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2023-07-18.
//

import XCTest
import Foundation

final class CapitalTableViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    // Test showing how you can scroll the screen with ease
    func testScrollingUpAndDown() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .scroll(direction: .down)
            .assertExists(.text(name: "Pakistan"))?
            .scroll(direction: .up)
            .assertExists(.text(name: "Nigeria"))
            
    }
  
    // Test showing how you can work with transitions between screens. assertTransition will
    // return a copy of the new screen, this means the scope of the screen is updated.
    func testSelectingCountryNavigatesToDetailsViewAndBack() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .tap(.text(name: "Ghana"))
            .assertTransition(to: CapitalView.self)?
            .assertExists(.backButton)? // Notice .backButton is an elemejnt of CapitalView
            .tap(.backButton)
            .assertTransition(to: CapitalTableView.self)?
            .assertExists(.title)
    }
    
    // Test showing you can iteract with items on the screen, in this case tap and double tap.
    func testSortingAllColumns() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .tap(.capitalHeader)
            .assertExists(.text(name: "Yerevan"))?
            .tap(.countryHeader)
            .assertExists(.text(name: "Algeria"))?
            .tap(.populationHeader)
            .assertExists(.text(name: "Chad"))?
            .doubleTap(.populationHeader)
            .assertExists(.text(name: "Chad"))
        
        // Also included are
        //  .doubleTap()
        //  .longPress()
        //  .swipe()
        //  .pullToRefresh()
        //  .drag()
        //
        // and more...
    }
    
    // Test that allows you to insert logic flow of the UI test. This is handy if you need to
    // react to compute something in a timely manner.
    func testExecutionBlock() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .pullToRefresh(elementAtLocation: .text(name: "Ghana"))
            .execute {
                // Check console logs to output
                print("Executing something in between steps!")
            }
            .scroll(direction: .up)
            .assertExists(.text(name: "Ghana"))
    }
    
    // Test that shows how you can use conditionals to determine if a step should be executed
    func testConditionBlock() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .pullToRefresh(elementAtLocation: .text(name: "Ghana"))
            .condition { tableView in
                // insert boolean logic here
                return true
            } action: { tableView in
                tableView
                    .tap(.text(name: "Ghana"))
                    .assertTransition(to: CapitalView.self)?
                    .tap(.backButton)
            }
            .assertTransition(to: CapitalTableView.self)
            
    }
    
    // Test that shows the validation of items on the screen.
    func testElementExistance() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .assertExists(.title)?
            .assertExists(.table)?
            .assertExists(.countryHeader)?
            .assertExists(.capitalHeader)?
            .assertExists(.populationHeader)?
            .assertExists(.populationHeader)?
            .assertExists(.text(name: "Ghana"))?
            .assertExists(.text(name: "United Arab Emirates"))?
            .assertDoesNotExist(.text(name: "fake non-existing country"))
    }
    
    // Test that shows how to print out the entire UI element tree so you can debug while writting tests
    func testPrintingElementsTree() throws {
        let app = XCUIApplication()
        app.launch()

        CapitalTableView(app)
            .debugPrintElements() // Look at the console for output
            .assertExists(.title)
    }
}
