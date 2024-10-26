import XCTest

final class Assignment_4UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetQuoteAndDelete() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Generate Quote Based on Mood"]/*[[".buttons[\"Generate Quote Based on Mood\"].staticTexts[\"Generate Quote Based on Mood\"]",".staticTexts[\"Generate Quote Based on Mood\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Get Quote"].tap()
        let textEditor = app.textViews["journalTextEditor"]
        XCTAssertTrue(textEditor.exists, "The text field does not exist")
        textEditor.tap()
        textEditor.typeText("Hello, world!")
        elementsQuery.buttons["Save Entry"].tap()
        XCUIApplication().alerts["Success"].scrollViews.otherElements.buttons["OK"].tap()
        elementsQuery.buttons["View Saved Data"].tap()
        let testTestTextInSavedData = app.staticTexts["Hello, world!"]
        XCTAssertTrue(testTestTextInSavedData.exists, "The 'Hello, world!' text was not found in the saved data!")
        let firstEntry = app.staticTexts["Hello, world!"]
        XCTAssertTrue(firstEntry.exists, "The first entry does not exist")
        firstEntry.swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertTrue(!testTestTextInSavedData.exists, "The 'Hello, world!' text was found in the saved data, after delete!")
        
    }
    
    func testCalendar() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["View Calendar"].tap()
        app.buttons["monthYearButton"].tap()
        app.pickers["Month"].pickerWheels.element.adjust(toPickerWheelValue: "February")
        app.pickers["Year"].pickerWheels.element.adjust(toPickerWheelValue: "2024")
        app.buttons["Done"].tap()
        let testTestTextInSavedData = app.staticTexts["29"]
        XCTAssertTrue(testTestTextInSavedData.exists, "The '29' text was not found in the Calendar!")
    }
    
    func testPassword() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Password Settings"].tap()
        
        
        let textEditorNewPassword = app.secureTextFields["newPassword"]
        XCTAssertTrue(textEditorNewPassword.exists, "The text field does not exist")
        textEditorNewPassword.tap()
        textEditorNewPassword.typeText("12345")
        let textEditorConfirm = app.secureTextFields["confirmPassword"]
        XCTAssertTrue(textEditorConfirm.exists, "The text field does not exist")
        textEditorConfirm.tap()
        textEditorConfirm.typeText("12345")
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Set Password"]/*[[".cells.buttons[\"Set Password\"]",".buttons[\"Set Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Alert"].scrollViews.otherElements.buttons["OK"].tap()
        
        app.terminate()
        app.launch()
        let testTestTextInSavedData = app.staticTexts["Enter Your Password"]
        XCTAssertTrue(testTestTextInSavedData.exists, "The 'Enter Your Password' text was not found in the saved data!")
        
        
        let textEditorPassword = app.secureTextFields["Password"]
        XCTAssertTrue(textEditorPassword.exists, "The text field does not exist")
        textEditorPassword.tap()
        textEditorPassword.typeText("12345")
        
        app.buttons["Unlock"].tap()
        sleep(2)
        app.buttons["Password Settings"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Remove Password"]/*[[".cells.buttons[\"Remove Password\"]",".buttons[\"Remove Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
