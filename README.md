# Pomegranate

This repository is a prototype for a Domain Specific Language aimed at making it easier to read and write UI Automation tests using Swift and the XCUITest framework provided by Apple. The idea came after returning to 6+ month old tests and scratching my head trying to figure out what they did and how.

The idea was to provide a pattern to abstract all the details of the XCUI testing framework and leverage the power of Xcode auto-completion.

Here's a very simple example of how a test looks with the DSL:

```Swift
func testTransitionFromScreen1AndBack() throws {
    let app = XCUIApplication()
    app.launch()

    Screen1(app)
        // Taps a button on Screen1 with a label "Go to Screen 2"
        .tap(.button(name: "Go to Screen 2"))
        // Ensures we transitioned to Screen2
        .assertTransition(to: Screen2.self)?
        // Ensure we are viewing the right screen by checking the title
        .assertExists(.title("Screen 2 Title"))
        // Tap the back button that should return us back to Screen 1
        .tap(.backButton)
        // Verify the transition and change context to Screen1
        .assertTransition(to: Screen1.self)?
        // Check a UI Element on Screen 1
        .assertExists(.title)
}
```

The overall structure revolves around creating a call chain from an implementation of a [Screen](https://github.com/etiennemartin/Pomegrante/blob/main/PomegranateUITests/Foundations/Screen.swift). A Screen is an abstraction layer around a UI component that contains a large section of the application. Given a `Screen` implementation, you can chain interactions and asserts to create an easy to read UI Automation test flow.

The code included in this repository contains a sample app, along with several UI Automation tests that can serve as examples. Feel free to browse around and see if you like it.

- [Sample UI tests](https://github.com/etiennemartin/Pomegrante/tree/main/PomegranateUITests)
- [Sample Screens](https://github.com/etiennemartin/Pomegrante/tree/main/PomegranateUITests/Screens)
- [DSL Foundations](https://github.com/etiennemartin/Pomegrante/tree/main/PomegranateUITests/Foundations)

## Anatomy of a Screen

Everything starts with the definiton of a `Screen`. Each "screen" inherit from the `Screen` protocol.

The following is an example of a screen:

```Swift
import XCXTest

class MyScreen: Screen {
  // The identifier is a top level accessibility identifier used to represent the highest level UI component
  // for the "screen"
  var identifier: String = "MyScreenName"

  // Boilerplate code :(
  var failableAsserts: Bool = true
  let app: XCUIApplication
  require init(_ app: XCUIApplication) {
    self.app = app
  }

  // This email is key in defining the UI components this creen will contain. Each case represents a
  // a single element, or the capability of targeting multiple elements (See case with parameters)
  enum Element: ElementRepresentable {
    case myButton
    case myLabel
    case table
    case labelInTable(String)
    case buttonWithLabel(String)
    case backButton

    var finder: ElementFinder {
      let e = ElementFinder()
      switch self {
        // Matches a button with the ID or text of "Press Me"
        case .myButton:
          return e.buttons("Press Me")
        // Matches a label on the screen with the text or ID "I'm a label!"
        case .myLabel
          return e.staticText("I'm a label!")
        // Matches a Table SwiftUI component with the accessibility label of "myTable"
        case .table:
          return e.collectionView("myTable")
        // Scoped Match for any label within the Table element that matches the text passed in
        case .labelInTable(let text):
          return e.collectionView("myTable").staticText(text)
        // Matches a button with a given label
        case .buttonWithLabel(let label):
          return e.button(label)
        // Matches a button with the "Back" label
        case .backButton
          return e.button("Back")
      }
    }
  }
}
```

## Examples

### Assertions

The `Screen` protocol offers many assertions to validate the screen in the state you expect.

```Swift
func testIteractions() throws {
    let app = XCUIApplication()
    app.launch()

    MyScreen(app)
        // asserts an element exists in the UI structure
        .assertExists(.myButton, timeout: .short)?
        // asserts a UIElement does not exist in the UI structure
        .assertDoesNotExists(.myButton, timeout: .short)?
        // asserts a UIElement is disabled
        .assertDisabled(.myButton, timeout: .short)?
        // asserts that a number of statisText elements exists in the UI Structure
        .assertLabelCount("title", 3, timeout: .short)?
        // asserts that there was a transition to another screen. This call will look at
        // the ID of the class and determine if it is present. If this succeeds, the
        // context returned in the chain will be an instance of the screen passed in
        .assertTransition(to: MyOtherScreen.self)?
        // asserts that a UI Element has focus
        .assertFocused(.myTextEntry)?

}
```

### Using interactions

The `Screen` class offers several interactions for the UIElement it contains. These actions are pretty straight forward.

```Swift
func testIteractions() throws {
    let app = XCUIApplication()
    app.launch()

    MyScreen(app)
        .tap(.button)
        .doubleTap(.button)
        .longPress(.button)
        .drag(.image, to: .dropBox)
        .swipe(.tableCell, direction: .left)
        .type("Text to enter in field")
        .scroll(.scrollView, direction: .down, velocity: .slow)
        .pullToRefresh()
        .keyboardAction(.dismiss)
}
```

### Using Conditionals

Conditional steps are made available using the `.condition(condition:, action:)` call. If the condition block returns false, the action is not executed.

```Swift
MyScreen(app)
  .pullToRefresh(elementAtLocation: .tableView)
  .condition { tableView in
      // insert boolean logic here
      return true
  } action: { tableView in
      tableView.tap(.actionButton)
  }
```

### Injecting code blocks

`.execute` can be used to run code blocks in the middle of a call chain.

```Swift
UploadScreen(app)
  .tap(.selectFileButton)
  .execute {
    FileManager.attachFileToScreen("/path/to/file")
  }
  .tap(.uploadButton)
  .assertExists(.successText)
```

### Debugging

Being able to see the entire UIElement tree structure can be very helpful while writing/debugging UI automation tests. You can print out the element tree at any point using `.debugPrintElements`.

```Swift
MyScreenToDebug(app)
  .debugPrintElements() // Outputs the entire UI Element tree to the console
```

## Technology used

- `Swift`
- `XCUI testing framework`
- `Xcode`
- `iOS`
