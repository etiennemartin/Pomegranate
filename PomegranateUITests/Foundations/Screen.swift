//
//  Screen.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2020-09-11.
//

import Foundation
import XCTest

/// Determines the direction of a swipe action on a `Screen`.
enum SwipeDirection {
    case up
    case down
    case left
    case right
}

enum ScrollDirection {
    case up
    case down
    case left
    case right
}

enum KeyboardAction {
    case dismiss
    case next
    
    var descriptor: String {
        switch self {
        case .dismiss:
            return "Hide keyboard"
        case .next:
            return "Next"
        }
    }
}

protocol ElementRepresentable {
    /// An instance of an object that can look up the given element representable
    var finder: ElementFinder { get }
}

protocol Screen: AnyObject {
    /// Base Automation application
    var app: XCUIApplication { get }
    
    /// Accessibility identifier associated to the root view of the screen.
    var identity: String { get }
    
    /// Determines if the asserts on UIElement are meant to be failable. This is set to false if we are using assertions
    /// to fulfill conditions on a screen
    var failableAsserts: Bool { get set }
    
    /// Definition of the UI elements contained on the current screen.
    associatedtype Element: ElementRepresentable
    
    /// Default initializer
    init(_ app: XCUIApplication)
}

// MARK: - Creation -

extension Screen {
    static func create(_ app: XCUIApplication) -> Self {
        return .init(app)
    }
    
    var keyboard: ElementFinder {
        ElementFinder().keyboards
    }
}

// MARK: - Actions -

extension Screen {
    
    /// This is a helpful debugger call that prints out the entire Element Tree in the console so you can see the current state
    /// of the Application
    @discardableResult
    func debugPrintElements() -> Self {
        print(app.debugDescription)
        return self
    }
    
    /// Waits until an element exists and taps it. If the element fails to exist before the timeout, the action fails
    /// - Parameters:
    ///        - element: The element to take action on
    @discardableResult
    func tap(_ element: Element) -> Self {
        element.finder.match(with: app).awaitEnabledAndTap()
        return self
    }
    
    /// Waits until an element exists and double taps it. If the element fails to exist before the timeout, the action fails
    /// - Parameters:
    ///        - element: The element to take action on
    @discardableResult
    func doubleTap(_ element: Element) -> Self {
        element.finder.match(with: app).awaitEnabledAndDoubleTap()
        return self
    }
    
    @discardableResult
    func longPress(_ element: Element) -> Self {
        element.finder.match(with: app).awaitExistAndLongPress()
        return self
    }
    
    @discardableResult
    func drag(_ sourceElement: Element, to targetElement: Element, andHold duration: TimeInterval = .short) -> Self {
        let source = sourceElement.finder.match(with: app)
        let target = targetElement.finder.match(with: app)
        source.awaitExistsAndDrag(target: target, hold: duration)
        return self
    }
    
    /// Waits until an element exists and attempts to swipe it. If the element fails to exist before the timeout, the action fails
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - direction: Determines which direction the swipe motion with move
    @discardableResult
    func swipe(_ element: Element, direction: SwipeDirection) -> Self {
        element.finder.match(with: app).awaitExistsAndSwipe(direction: direction)
        return self
    }
    
    /// Types in a given string onto the focused element. If no element is in focus an error will be raised.
    /// - Parameters:
    ///     - value: String you wish to type into the focused element
    @discardableResult
    func type(_ value: String) -> Self {
        app.typeText(value)
        return self
    }
    
    /// Types given string in the FieldCell with `overwriteDisplayValueWhileEditing` behaviour
    /// - Parameters:
    ///     - value: String you wish to type
    ///     - element: Specific element you wish to type the text
    func typeInFieldCellWithOverwriteDisplayValueWhileEditingBehaviour(_ value: String, element: Element) -> Self {
        UIPasteboard.general.string = value
        element.finder.match(with: app).doubleTap()
        app.menuItems["Paste"].tap()
        return self
    }
    
    /// Scrolls either the specififed element or the screen's identified view based on the visual direction with a given velocity
    /// - Parameters:
    ///     - element: Specific element you wish to scroll, nil defaults to the screen's identified view
    ///     - direction: The visual direction you wish to scroll
    ///     - velocity: The speed at which you want to scroll (default, slow, fast)
    @discardableResult
    func scroll(element: Element? = nil, direction: ScrollDirection, velocity: XCUIGestureVelocity = .default) -> Self {
        if let element = element {
            let matched = element.finder.match(with: app)
            if matched.awaitExists() {
                matched.scroll(direction: direction, velocity: velocity)
            } else {
                XCTFail("Failed to find \(element) while trying to scroll")
            }
        } else {
            // Pull screen's view
            let matched = ElementFinder().identifier(identity).match(with: app)
            if matched.awaitExists() {
                matched.scroll(direction: direction, velocity: velocity)
            } else {
                XCTFail("Attempting to scroll screen. Maybe try to specify an element or make sure you are on the screen specified by the identifier: \(identity).")
            }
        }
        
        return self
    }
    
    /// Performs a pull-to-refresh action on the given element
    /// - Parameters:
    ///     - elementAtLocation: Specific element that is at the location where the pull-to-refresh gesture should begin; typically the first cell
    @discardableResult
    func pullToRefresh(elementAtLocation: Element) -> Self {
        let matchedElement = elementAtLocation.finder.match(with: app)
        if matchedElement.awaitExists() {
            let startCoordinate = matchedElement.coordinate(withNormalizedOffset: .zero)
            let endCoordinate = matchedElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
            startCoordinate.press(forDuration: 0, thenDragTo: endCoordinate)
        } else {
            XCTFail("Failed to find \(matchedElement) while trying to perform a pull-to-refresh gesture")
        }
        return self
    }
    
    /// Executes an action on the keyboard
    /// - Parameters:
    ///     - action: The keyboard action you want to execute
    @discardableResult
    func keyboardAction(_ action: KeyboardAction) -> Self {
        let matched = keyboard.button(action.descriptor).match(with: app)
        if matched.awaitExists() {
            matched.tap()
        } else {
            XCTFail("Unable to execute keyboard action: `\(action.descriptor)`. Please make sure the keyboard you're interacting with supports this action")
        }
        
        return self
    }
}

// MARK: - Conditionals -

extension Screen {
    /// Executes a block that if it returns true, will execute an action. This adds the ability to add conditional logic to the
    /// tests. This method should only be used if we have well known branching logic, or a precondition that MAY occur for a
    /// test to run smoothly. (i.e. clean up or prepate data before the test.
    /// - Parameters:
    ///        - condition: A block that returns true or false. If true the action will be executed
    ///        - action: A block that is executed if the condition is met and the condition block returns true.
    @discardableResult
    func condition(_ condition: (Self) -> Bool, action: (Self) -> Void) -> Self {
        failableAsserts = false
        if condition(self) {
            failableAsserts = true
            action(self)
        } else {
            failableAsserts = true
        }
        
        return self
    }

    /// Checks the current interface idiom and executes the matching block. Useful for situations where there are UI inconsistencies between tablets and phones.
    /// - Parameters:
    ///   - tablet: A block that is executed if the idiom is tablet
    ///   - phone: A block that is executed if the idiom is phone
    func platform(tablet: ((Self) -> Void)? = nil, phone: ((Self) -> Void)? = nil) -> Self {
        let currentIdiom = UIDevice.current.userInterfaceIdiom
        if currentIdiom == .pad {
            tablet?(self)
        } else if currentIdiom == .phone {
            phone?(self)
        } else {
            XCTFail("Idiom \(currentIdiom) was found, expected .pad or .phone")
        }
        
        return self
    }
}

// MARK: - Assertions -

extension Screen {
    /// Waits until an element exists. If the element fails to exist before the timeout, the test will fail.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertExists(_ elements: Element..., timeout: TimeInterval = .short) -> Self? {
        return processElements(elements) { element -> Bool in
            element.finder.match(with: app).awaitExists(timeout: timeout)
        }
    }
    
    /// Waits until an element disappears (exists = false). If the element fails does not cease to exist before the timeout, the test will fail.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertDoesNotExist(_ elements: Element..., timeout: TimeInterval = .short) -> Self? {
        return processElements(elements) { element -> Bool in
            element.finder.match(with: app).awaitNotExists(timeout: timeout)
        }
    }
    
    /// Waits until an element to be enabled. If the element fails does become enabled before the timeout, the test will fail.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertEnabled(_ elements: Element..., timeout: TimeInterval = .short) -> Self? {
        return processElements(elements) { element -> Bool in
            element.finder.match(with: app).awaitEnabled(timeout: timeout)
        }
    }
    
    /// Waits until an element to be disabled. If the element fails does become disabled before the timeout, the test will fail.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertDisabled(_ elements: Element..., timeout: TimeInterval = .short) -> Self? {
        return processElements(elements) { element -> Bool in
            element.finder.match(with: app).awaitDisabled(timeout: timeout)
        }
    }
    
    /// Counts the number of static text elements (Labels) exist under an element.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertLabelCount(_ value: String, count: Int, timeout: TimeInterval = .short) -> Self? {
        let found = app.staticTexts.matching(identifier: value).count
        if found == count {
            return self
        } else {
            XCTFail("Label \(value) was found \(found) times, expected \(count)")
            return failableAsserts ? self : nil // Only return nil if we don't want asserts to fail
        }
    }
    
    /// Asserts that a transition to succeeds. Each screen provides an accessibility identifier assigned by `Screen.identity` which
    /// we wait until it exists. This method will return a copy of the screen that you expected to transition towards.
    /// - Parameters:
    ///        - screen: Screen type that is where the test is extected to transition to.
    @discardableResult
    func assertTransition<S: Screen>(to screen: S.Type) -> S? {
        let realized = screen.create(app)
        let finder = ElementFinder().identifier(realized.identity)
        if finder.match(with: app).awaitExists() {
            return realized
        } else {
            XCTFail("Transition to screen \(realized) failed.")
        }

        return failableAsserts ? realized : nil // Only return nil if we don't want asserts to fail
    }
    
    /// Waits until the element exists and validates it's existance. If the element doesn't have focus it will fail.
    /// - Parameters:
    ///        - element: The element to take action on
    ///        - timeout: Time interval to wait for existance before failing. Default is .short
    @discardableResult
    func assertFocused(_ elements: Element..., timeout: TimeInterval = .short) -> Self? {
        return processElements(elements) { element -> Bool in
            element.finder.match(with: app).awaitFocus(timeout: timeout)
        }
    }
    
    /// Executes an arbitrary block of code. This allows us to break up the execution chain to call outside the scope of the UI Automation test.
    /// A good example of this is if we need to control something outside the scope of the app itself. It can be done here.
    /// - Parameters:
    ///        - block: Block of code to execute
    @discardableResult
    func execute(_ block: () -> Void) -> Self {
        block()
        return self
    }
    
    /// Takes a set of given set of elements and takes action of each of the elements.
    private func processElements(_ elements: [Element], action: (Element) -> Bool) -> Self? {
        var succeeded = true
        elements.forEach {
            if !action($0) {
                if failableAsserts {
                    XCTFail("Failed to process action on element. \($0)")
                } else {
                    succeeded = false
                }
            }
        }
        
        if !succeeded && !failableAsserts {
            return nil
        }
        return self
    }
}

// MARK: - Input -

extension Screen {
    /// Manual entry of numbers using the keypad. This is more consistent since `typeText` misses nearly every second tap.
    /// - Parameters:
    ///        - value: A numeric number you wish to enter using the numeric keypad
    ///        - proceed: A Boolean value that determines if the "Done" or "Proceed" button the keypad is tapped at the end. This can be useful to move the data entry flow forward
    @discardableResult
    func tapNumericKeys(_ value: UInt, andProceed proceed: Bool = false) -> Self {
        let string = "\(value)"
        var withholdingZero = false
        for (index, character) in string.enumerated() {
            let isLastCharacter = index == string.count - 1
            switch (character, withholdingZero, isLastCharacter) {
            case ("0", false, false):
                // do nothing; see if we can speed up by tapping '00' instead
                withholdingZero = true
            case ("0", true, _):
                app.buttons["00"].tap()
                withholdingZero = false
            case (_, true, _):
                app.buttons["0"].tap()
                withholdingZero = false
                app.buttons[String(character)].tap()
            default:
                app.buttons[String(character)].tap()
            }
        }
        
        if proceed {
            app.buttons["returnKeyEnabled"].awaitEnabledAndTap()
        }
        
        return self
    }

    /// Dismisses the numeric keyboard by tapping the dismiss keyboard button
    @discardableResult
    func dismissNumericKeyboard() -> Self {
        app.buttons["numeric.keyboard.hide"].tap()

        return self
    }
    
    /// Clears the text in the element.
    /// - Parameters:
    ///        - element: The element to take action on
    @discardableResult
    func clearText(_ element: Element) -> Self {
        element.finder.match(with: app).clearText()
        return self
    }
}
