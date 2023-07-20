//
//  ElementFinder.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2020-10-13.
//

import Foundation
import XCTest

class ElementFinder {
    /// These types are going to help us map a defined query chain to an actual XCUIElement query. It might not be complete with what Apple provides.
    enum ElementType {
        /// Do not use this element. This is meant to represent the root element when we build the query chain in the `match` method
        case root
        
        case button(String?)
        case cell(String?)
        case collectionView(String?)
        case dialog(String?)
        case identifier(String?)
        case image(String?)
        case link(String?)
        case menuBar(String?)
        case menuBarItem(String?)
        case menuItem(String?)
        case navigationBar(String?)
        case picker(String?)
        case segmentedControl(String?)
        case searchField(String?)
        case staticText(String?)
        case `switch`(String?)
        case scrollBar(String?)
        case scrollView(String?)
        case tab(String?)
        case table(String?)
        case textField(String?)
        case toggle(String?)
        case toolbar(String?)
        case keyboard(String?)
    }
    
    var type: ElementType
    var lineage: [ElementFinder]
    
    /// Root initializer
    init() {
        self.type = .root
        self.lineage = []
    }
    
    init(type: ElementType, lineage: [ElementFinder] = []) {
        self.type = type
        self.lineage = lineage
    }
    
    /// Creates an element finder of a given type with it's current lineage (hierarchy) of element including itself.
    private func elementFinder(with type: ElementType) -> ElementFinder {
        lineage.append(self)
        let matcher = ElementFinder(type: type, lineage: lineage)
        return matcher
    }
    
    /// Target all button elements
    var buttons: ElementFinder { return elementFinder(with: .button(nil)) }
    /// Target a single button for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func button(_ id: String) -> ElementFinder {
        return elementFinder(with: .button(id))
    }
    
    /// Target all cell elements
    var cells: ElementFinder { return elementFinder(with: .cell(nil)) }
    /// Target a single cell for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func cell(_ id: String) -> ElementFinder {
        return elementFinder(with: .cell(id))
    }
    
    /// Target all collection view elements
    var collectionViews: ElementFinder { return elementFinder(with: .collectionView(nil)) }
    /// Target a single collection view for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func collectionView(_ id: String) -> ElementFinder {
        return elementFinder(with: .collectionView(id))
    }
    
    /// Target all dialog elements
    var dialogs: ElementFinder { return elementFinder(with: .dialog(nil)) }
    /// Target a single dialog for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func dialog(_ id: String) -> ElementFinder {
        return elementFinder(with: .dialog(id))
    }
    
    /// Target a single element for a given accessibility identifier.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func identifier(_ id: String) -> ElementFinder {
        return elementFinder(with: .identifier(id))
    }

    /// Target all image elements
    var images: ElementFinder { return elementFinder(with: .image(nil)) }
    /// Target a single image for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func image(_ id: String) -> ElementFinder {
        return elementFinder(with: .image(id))
    }
    
    /// Target all link elements
    var links: ElementFinder { return elementFinder(with: .link(nil)) }
    /// Target a single link for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func link(_ id: String) -> ElementFinder {
        return elementFinder(with: .link(id))
    }
    
    /// Target all menu bar elements
    var menuBars: ElementFinder { return elementFinder(with: .menuBar(nil)) }
    /// Target a single menu bar for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func menuBar(_ id: String) -> ElementFinder {
        return elementFinder(with: .menuBar(id))
    }
    
    /// Target all menu bar item elements
    var menuBarItems: ElementFinder { return elementFinder(with: .menuBarItem(nil)) }
    /// Target a single menu bar item for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func menuBarItem(_ id: String) -> ElementFinder {
        return elementFinder(with: .menuBarItem(id))
    }
    
    /// Target all menu item elements
    var menuItems: ElementFinder { return elementFinder(with: .menuItem(nil)) }
    /// Target a single menu item for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func menuItem(_ id: String) -> ElementFinder {
        return elementFinder(with: .menuItem(id))
    }
    
    /// Target all navigation bar elements
    var navigationBars: ElementFinder { return elementFinder(with: .navigationBar(nil)) }
    /// Target a single navigation bar for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func navigationBar(_ id: String) -> ElementFinder {
        return elementFinder(with: .navigationBar(id))
    }

    /// Target all picker elements
    var pickers: ElementFinder { return elementFinder(with: .picker(nil)) }
    /// Target a single picker for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func picker(_ id: String) -> ElementFinder {
        return elementFinder(with: .picker(id))
    }
    
    /// Target all static text (Label) elements
    var staticTexts: ElementFinder { return elementFinder(with: .staticText(nil)) }
    /// Target a single static text (Label) for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func staticText(_ id: String) -> ElementFinder {
        return elementFinder(with: .staticText(id))
    }
    
    /// Target all switch elements
    var switches: ElementFinder { return elementFinder(with: .switch(nil)) }
    /// Target a single switch for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func `switch`(_ id: String) -> ElementFinder {
        return elementFinder(with: .switch(id))
    }
    
    /// Target all scroll bar elements
    var scrollBars: ElementFinder { return elementFinder(with: .scrollBar(nil)) }
    /// Target a single scroll bar for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func scrollBar(_ id: String) -> ElementFinder {
        return elementFinder(with: .scrollBar(id))
    }
    
    /// Target all scroll view elements
    var scrollViews: ElementFinder { return elementFinder(with: .scrollView(nil)) }
    /// Target a single cell for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func scrollView(_ id: String) -> ElementFinder {
        return elementFinder(with: .scrollView(id))
    }
    
    /// Target all tab elements
    var tabs: ElementFinder { return elementFinder(with: .tab(nil)) }
    /// Target a single tab for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func tab(_ id: String) -> ElementFinder {
        return elementFinder(with: .tab(id))
    }
    
    /// Target all table elements
    var tables: ElementFinder { return elementFinder(with: .table(nil)) }
    /// Target a single table for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func table(_ id: String) -> ElementFinder {
        return elementFinder(with: .table(id))
    }
    
    /// Target all textFields elements
    var textFields: ElementFinder { return elementFinder(with: .textField(nil)) }

    /// Target all text field elements
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func textField(_ id: String) -> ElementFinder {
        return elementFinder(with: .textField(id))
    }
    
    /// Target all search field elements
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func searchField(_ id: String) -> ElementFinder {
        return elementFinder(with: .searchField(id))
    }
    
    /// Target all toggle elements
    var toggles: ElementFinder { return elementFinder(with: .toggle(nil)) }
    /// Target a single toggle for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func toggle(_ id: String) -> ElementFinder {
        return elementFinder(with: .toggle(id))
    }
    
    /// Target all tool bar elements
    var toolbars: ElementFinder { return elementFinder(with: .toolbar(nil)) }
    /// Target a single tool bar for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func toolbar(_ id: String) -> ElementFinder {
        return elementFinder(with: .toolbar(id))
    }
    
    /// Targets main keyboard
    var keyboards: ElementFinder { return elementFinder(with: .keyboard(nil)) }
    /// Target a keyboard for a given id.
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func keyboard(_ id: String) -> ElementFinder {
        return elementFinder(with: .keyboard(id))
    }
    
    /// Target all segmented control elements
    var segmentedControls: ElementFinder { return elementFinder(with: .segmentedControl(nil)) }
    /// Target a single segmented control with a given id
    /// - Parameters:
    ///        - id: String id that can match against accessibility identifier or label
    func segmentedControl(_ id: String) -> ElementFinder {
        return elementFinder(with: .segmentedControl(id))
    }
    
    /// This method will take a given ElementFinder and traverse it's lineage to build an query that it will execute and return it's first match.
    /// - Parameters:
    ///        - root: The base element where the query starts to be crafted. Usually we start from an XCUIApplication instance.
    func match(with root: XCUIElementTypeQueryProvider) -> XCUIElement {
        var query = root
        
        // Add the last child to the lineage since it doesn't include itself
        var fullLineage = lineage
        fullLineage.append(self)
        
        // Build up query based on type and ID
        fullLineage.forEach { finder in
            switch finder.type {
            case .root:
                break // Skip
            case .button(let id):
                if let id = id {
                    query = query.buttons[id]
                } else {
                    query = query.buttons
                }
            case .cell(let id):
                if let id = id {
                    query = query.cells[id]
                } else {
                    query = query.cells
                }
            case .collectionView(let id):
                if let id = id {
                    query = query.collectionViews[id]
                } else {
                    query = query.collectionViews
                }
            case .dialog(let id):
                if let id = id {
                    query = query.dialogs[id]
                } else {
                    query = query.dialogs
                }
            case .identifier(let id):
                if let id = id {
                    query = query.otherElements.matching(identifier: id)
                } else {
                    assert(false, "Must specify an ID for the type .identifier.")
                    break
                }
            case .image(let id):
                if let id = id {
                    query = query.images[id]
                } else {
                    query = query.images
                }
            case .link(let id):
                if let id = id {
                    query = query.links[id]
                } else {
                    query = query.links
                }
            case .menuBar(let id):
                if let id = id {
                    query = query.menuBars[id]
                } else {
                    query = query.menuBars
                }
            case .menuBarItem(let id):
                if let id = id {
                    query = query.menuBarItems[id]
                } else {
                    query = query.menuBarItems
                }
            case .menuItem(let id):
                if let id = id {
                    query = query.menuItems[id]
                } else {
                    query = query.menuItems
                }
            case .navigationBar(let id):
                if let id = id {
                    query = query.navigationBars[id]
                } else {
                    query = query.navigationBars
                }
            case .picker(let id):
                if let id = id {
                    query = query.pickers[id]
                } else {
                    query = query.pickers
                }
            case .segmentedControl(let id):
                if let id = id {
                    query = query.segmentedControls[id]
                } else {
                    query = query.segmentedControls
                }
            case .searchField(let id):
                if let id = id {
                    query = query.searchFields[id]
                } else {
                    query = query.searchFields
                }
            case .staticText(let id):
                if let id = id {
                    query = query.staticTexts[id]
                } else {
                    query = query.staticTexts
                }
            case .switch(let id):
                if let id = id {
                    query = query.switches[id]
                } else {
                    query = query.switches
                }
            case .scrollBar(let id):
                if let id = id {
                    query = query.scrollBars[id]
                } else {
                    query = query.scrollBars
                }
            case .scrollView(let id):
                if let id = id {
                    query = query.scrollViews[id]
                } else {
                    query = query.scrollViews
                }
            case .tab(let id):
                if let id = id {
                    query = query.tabs[id]
                } else {
                    query = query.tabs
                }
            case .table(let id):
                if let id = id {
                    query = query.tables[id]
                } else {
                    query = query.tables
                }
            case .textField(let id):
                if let id = id {
                    query = query.textFields[id]
                } else {
                    query = query.textFields
                }
            case .toggle(let id):
                if let id = id {
                    query = query.toggles[id]
                } else {
                    query = query.toggles
                }
            case .toolbar(let id):
                if let id = id {
                    query = query.toolbars[id]
                } else {
                    query = query.toolbars
                }
            case .keyboard(let id):
                if let id = id {
                    query = query.keyboards[id]
                } else {
                    query = query.keyboards.element(boundBy: 0)
                }
            }
        }
        
        return query.firstMatch // Executes query
    }
    
}
