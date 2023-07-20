//
//  XCUIElement+Waiting.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2020-09-11.
//

import XCTest

extension XCUIElement {
    /// Takes in a string predicate that's evaluated over time. Returns true if it suceeded, false otherwise
    /// - Parameters:
    ///     - predicate: String that will be evaluated in an NSPredicate against self
    ///        - timeout: Amount of time to wait before failing
    private func waitForPredicate(_ predicate: String, timeout: TimeInterval = .short) -> Bool {
        let predicate = NSPredicate(format: predicate)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        expectation.perform(NSSelectorFromString("setPollingInterval:"), with: 0.2)
        let results = XCTWaiter().wait(for: [expectation], timeout: timeout)
        
        if results != .completed { screenshot() }
        return results == .completed
    }
    
    // MARK: - Existence -
    
    /// Waits for an element to exist or timeout exceeds
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitExists(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("exists == true", timeout: timeout)
    }
    
    /// Waits for an element to disappear or timeout exceeds
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitNotExists(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("exists == false", timeout: timeout)
    }
    
    // MARK: - State -
    
    /// Waits for an element to become enabled or timeout exceeds
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitEnabled(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("enabled == true", timeout: timeout)
    }
    
    /// Waits for an element to become disabled or timeout exceeds
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitDisabled(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("enabled == false", timeout: timeout)
    }
    
    /// Waits for an element to become hittable or timeout exceeds
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    func awaitHittable(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("hittable == true", timeout: timeout)
    }
    
    // MARK: - Actions -
    
    /// Waits for an element to exist and tap.
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitEnabledAndTap(timeout: TimeInterval = .short) -> Bool {
        if awaitEnabled(timeout: timeout) {
            tap()
            return true
        } else {
            screenshot()
            return false
        }
    }
    
    /// Waits for an element to exist and double tap.
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitEnabledAndDoubleTap(timeout: TimeInterval = .short) -> Bool {
        if awaitEnabled(timeout: timeout) {
            doubleTap()
            return true
        } else {
            screenshot()
            return false
        }
    }

    /// Waits for an element to exist and swipe in a given direction.
    /// - Parameters:
    ///     - direction: The direction to perform the swipe
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitExistsAndSwipe(direction: SwipeDirection, timeout: TimeInterval = .short, velocity: XCUIGestureVelocity = .fast) -> Bool {
        if awaitExists(timeout: timeout) {
            switch direction {
            case .up:
                swipeUp(velocity: velocity)
            case .down:
                swipeDown(velocity: velocity)
            case .left:
                swipeLeft(velocity: velocity)
            case .right:
                swipeRight(velocity: velocity)
            }
            return true
        } else {
            screenshot()
            return false
        }
    }
    
    /// Waits for an element to exist and long presses on that element for a given duration.
    /// - Parameters:
    ///     - duration: How long the tap should last
    ///        - timeout: Amount of time to wait before failing
    @discardableResult
    func awaitExistAndLongPress(duration: TimeInterval = .short, timeout: TimeInterval = .short) -> Bool {
        if awaitExists(timeout: timeout) {
            press(forDuration: duration)
            return true
        } else {
            screenshot()
            return false
        }
    }
    
    /// Waits for an element to exist, then long presses and drags to a target element. Optionally it can hold that final position for some time.
    /// - Parameters:
    ///     - taret: The element you wish to drag on top of
    ///        - hold: How long to hold on top of the target element
    @discardableResult
    func awaitExistsAndDrag(target: XCUIElement, hold: TimeInterval = .short) -> Bool {
        if awaitExists() {
            press(forDuration: .short, thenDragTo: target, withVelocity: .default, thenHoldForDuration: hold)
            return true
        } else {
            screenshot()
            return false
        }
    }
    
    /// Scrolls the view in the direction and velocity specified.
    /// - Parameters:
    ///     - direction: Visual representation of the direction we want to move
    ///        - velocity: Speed of scrolling
    func scroll(direction: ScrollDirection, velocity: XCUIGestureVelocity = .default) {
        switch direction {
        case .up:
            swipeDown(velocity: velocity)
        case .down:
            swipeUp(velocity: velocity)
        case .left:
            swipeRight(velocity: velocity)
        case .right:
            swipeLeft(velocity: velocity)
        }
    }
    
    /// Attempts to clear the data entry of a field if possible.
    func clearText() {
        guard let stringValue = value as? String else {
            XCTFail("Attempted to clear the textfield and failed.")
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
    
    /// Waits for an element to have focus in order to type.
    /// - Parameters:
    ///        - timeout: Amount of time to wait before failing
    func awaitFocus(timeout: TimeInterval = .short) -> Bool {
        return waitForPredicate("hasKeyboardFocus == true", timeout: timeout)
    }
    
    /// Takes a snapshot of an element and adds it to the XCResults bundle as an attachment
    /// - Parameters:
    ///        - message: The name of the attachment.
    private func elementScreenShot(message: String) {
        XCTContext.runActivity(named: message) { [weak self] activity in
            guard let self = self else { return }
            let screenshot = self.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
    
    /// Takes a snapshot of an entire screen and adds it to the XCResults bundle as an attachment
    /// - Parameters:
    ///        - message: The name of the attachment.
    private func screenshot(message: String) {
        XCTContext.runActivity(named: message) { activity in
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
}
