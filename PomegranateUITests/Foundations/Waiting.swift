//
//  Waiting.swift
//  PomegranateUITests
//
//  Created by Etienne Martin on 2020-09-10.
//

import Foundation
import XCTest

/// This method will create it's own run loop that will periodically check a condition for success criteria. The call will end if either
/// the timeout is reached or the condition is met. This method is used to wait for condition without tying it directly to XCUIElement
/// XCUIApplication or the XCTestCase itself.
///
/// Ported from: https://pspdfkit.com/blog/2016/running-ui-tests-with-ludicrous-speed/
///
/// - Parameters:
///        - timeout: The amount of time the method should try to meet the condition parameter before failing.
///        - condition: A bool that return true if the given condition is met or not.
func waitForCondition(timeout: TimeInterval, condition: @autoclosure @escaping () -> Bool) -> Bool {
    var fulfilled = false
    let beforeWaiting: (CFRunLoopObserver?, CFRunLoopActivity) -> Void = { (observer, activity) in
        // Pre-condition
        guard !fulfilled else { return }
        // Check the condition
        fulfilled = condition()
        // Condition fulfilled: stop RunLoop now
        if fulfilled {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }
    
    // We add a timer dispatch source here to make sure that we wake up at least every 0.x seconds
    // in case we're waiting for a condition that does not necessarily wake up the run loop.
    let timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: .nanoseconds(1))
    timer.setEventHandler { /* NOOP */ }
    timer.resume()

    var observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, beforeWaiting)
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
    CFRunLoopRunInMode(CFRunLoopMode.defaultMode, timeout, false)
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
    observer = nil
    
    timer.cancel()
    
    // If we haven't fulfilled the condition yet, test one more time before returning. This avoids
    // that we fail the test just because we somehow failed to properly poll the condition, e.g. if
    // the run loop didn't wake up.
    if !fulfilled {
        fulfilled = condition()
    }
    
    return fulfilled
}
