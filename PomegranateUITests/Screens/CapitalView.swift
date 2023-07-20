//
//  CapitalView.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2023-07-19.
//

import XCTest

class CapitalView: Screen {
    /// Accessibility identifier of the highest possible UI element. This helps determine if the UI component
    /// is visible on the screen and helps us get `assertTransition` to work.
    var identity: String = "CapitalView"
    var failableAsserts: Bool = true
    
    let app: XCUIApplication
    
    required init(_ app: XCUIApplication) {
        self.app = app
    }
    
    /// Representation of all the elements you can access on the screen.
    enum Element: ElementRepresentable {
        case flag
        case name
        case country
        case textEntry(String)
        case population(String)
        case percentagePop(Float)
        case backButton
        
        /// Determines how the XCUI Test framework queries for the UI Element
        var finder: ElementFinder {
            let e = ElementFinder()
            switch self {
            case .flag:
                return e.staticText("CapitalView.Flag")
            case .name:
                return e.staticText("CapitalView.Name")
            case .country:
                return e.staticText("CapitalView.Country")
            case .textEntry(let text):
                return e.staticText(text)
            case .population(let population):
                // Example of how you can narrow down the scope to ensure you have the right element
                return e.identifier("CapitalView.PopulationStack").staticText("Population: \(population)")
            case .percentagePop(let percentage):
                return e.identifier("CapitalView.PopulationStack").staticText("Percentage of Country's pop: \(String(format: "%.2f", percentage))%")
            case .backButton:
                return e.button("Back")
            }
        }
    }
}
