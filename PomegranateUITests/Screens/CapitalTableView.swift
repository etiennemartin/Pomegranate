//
//  CapitalTableView.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2023-07-19.
//

import XCTest

class CapitalTableView: Screen {
    /// Accessibility identifier of the highest possible UI element. This helps determine if the UI component
    /// is visible on the screen and helps us get `assertTransition` to work.
    var identity: String = "CapitalTableView"
    var failableAsserts: Bool = true
    
    let app: XCUIApplication
    
    required init(_ app: XCUIApplication) {
        self.app = app
    }
    
    /// Representation of all the elements you can access on the screen.
    enum Element: ElementRepresentable {
        case title
        case table
        case capitalHeader
        case countryHeader
        case populationHeader
        case text(name: String)
        
        /// Determines how the XCUI Test framework queries for the UI Element
        var finder: ElementFinder {
            let e = ElementFinder()
            switch self {
            case .title:
                return e.staticText("Top 100 Capitals")
            case .table:
                return e.collectionView("CapitalTableView.Table")
            case .capitalHeader:
                return e.button("Capital")
            case .countryHeader:
                return e.button("Country")
            case .populationHeader:
                return e.button("Population")
            case .text(let name):
                return e.staticText(name)
            }
        }
    }
}
