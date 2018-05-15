//
//  Aventus_HomepageUITests.swift
//  Aventus HomepageUITests
//
//  Created by Weixiong Tay on 03/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import XCTest

class Aventus_HomepageUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuy() {
      
        
        let app = XCUIApplication()
        
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeLeft()
        
        let element = app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        element.tap()
        
        
        
        let pickerWheel = app/*@START_MENU_TOKEN@*/.pickerWheels["0"]/*[[".pickers.pickerWheels[\"0\"]",".pickerWheels[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pickerWheel/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pickerWheel.swipeUp()
        app.buttons["PURCHASE"].tap()
        
        let cardholderSNameTextField = app.textFields["Cardholder's name"]
        cardholderSNameTextField.tap()
        cardholderSNameTextField.typeText("a")
        
        let cardNumberTextField = app.textFields["Card Number"]
        cardNumberTextField.tap()
        cardNumberTextField.tap()
        cardNumberTextField.typeText("a")
        
        let mmYyTextField = app.textFields["MM/YY"]
        mmYyTextField.tap()
        mmYyTextField.tap()
        mmYyTextField.typeText("a")
        
        let cvvTextField = app.textFields["CVV"]
        cvvTextField.tap()
        cvvTextField.tap()
        cvvTextField.typeText("a")
        app.buttons["CONFIRM"].tap()
        app.buttons["homeIcon"].tap()
        
        
                        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testTableView(){
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        
        let collectionViewsQuery = app.collectionViews
        let element2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element
        element2.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.swipeUp()
        element2.swipeUp()
        element.swipeRight()
        
    }
    
    func testMenuBar(){
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 1).tap()
        
        let button = element.children(matching: .button).element(boundBy: 0)
        button.tap()
        button.tap()
        
        let helpButton = app.buttons["  Help"]
        helpButton.tap()
        app.staticTexts["\"Buy me two standing tickets to Rihanna on 19th May\""].tap()
        element.swipeLeft()
        element.tap()
        
        let menuButton = app.buttons["menu"]
        menuButton.tap()
        helpButton.tap()
        app.staticTexts["\"Don't show me Justin Bieber events\""].tap()
        
        let element2 = app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element2.tap()
        
        
    }
    
    func testTicket(){
        
        
        let app = XCUIApplication()
        app.buttons["menu"].tap()
        app.buttons["  Ticket"].tap()
        
        let rihannaStaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Rihanna"]/*[[".otherElements[\"Rihanna\"].staticTexts[\"Rihanna\"]",".staticTexts[\"Rihanna\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rihannaStaticText.tap()
        rihannaStaticText.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        
    }
    
    func testMic(){

        
        let app = XCUIApplication()
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        
        let icons8Microphone96Button = app.buttons["icons8 microphone 96"]
        icons8Microphone96Button.tap()
        
        let microphoneOnButton = app.buttons["microphone on"]
        microphoneOnButton.tap()
        
    }
    
    func testMic2(){
        
        
        let app = XCUIApplication()
        app.buttons["icons8 microphone 96"].tap()
        app.buttons["microphone on"].tap()
        
        
        
    }
    
    func testSeatpopup()
    {
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["seatLayoutPopUp"]/*[[".buttons[\"Layout\"]",".buttons[\"seatLayoutPopUp\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        app.buttons["PURCHASE"].tap()
        
    }
    
    
    func testTicketView(){
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element.children(matching: .other).element.swipeLeft()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["RIHANNA London"]/*[[".cells.staticTexts[\"RIHANNA London\"]",".staticTexts[\"RIHANNA London\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["0"]/*[[".pickers.pickerWheels[\"0\"]",".pickerWheels[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.buttons["PURCHASE"].tap()
        
        let cardholderSNameTextField = app.textFields["Cardholder's name"]
        cardholderSNameTextField.tap()
        cardholderSNameTextField.typeText("s")
        
        let cardNumberTextField = app.textFields["Card Number"]
        cardNumberTextField.tap()
        cardNumberTextField.tap()
        cardNumberTextField.typeText("s")
        
        let mmYyTextField = app.textFields["MM/YY"]
        mmYyTextField.tap()
        mmYyTextField.typeText("s")
        
        let cvvTextField = app.textFields["CVV"]
        cvvTextField.tap()
        cvvTextField.tap()
        cvvTextField.typeText("s")
        app.buttons["CONFIRM"].tap()
        app.buttons["ticketIcon"].tap()
        element.tap()
        
    }
}
