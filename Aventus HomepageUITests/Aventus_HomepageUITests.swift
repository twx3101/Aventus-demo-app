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
    
    func testOverall() {
        
        let app = XCUIApplication()
        app.staticTexts["\"I want to see Drake.\""].tap()
        app.staticTexts["\"Inspire me!\""].tap()
        app.otherElements.containing(.navigationBar, identifier:"UITabBar").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["London"].swipeUp()
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let element = cell.children(matching: .other).element(boundBy: 0)
        element.swipeUp()
        
       element.tap()
        
        
        let upButton = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"402,404")/*[[".cells.containing(.staticText, identifier:\"98\")",".cells.containing(.staticText, identifier:\"75\")",".cells.containing(.staticText, identifier:\"402,404\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Up"]
        upButton.tap()
        tablesQuery.buttons["Purchase"].tap()
        app.buttons["Confirm"].tap()
        app.navigationBars["Aventus_Homepage.ConfirmationView"].buttons["Back"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["101,102,104,105"]/*[[".cells.staticTexts[\"101,102,104,105\"]",".staticTexts[\"101,102,104,105\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

                        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testTableView(){
        
    }
    
    func testSeguetransition(){
        
    }
    
    func testTicket(){
        
    }
    
    func testPayment(){
        
    }
}
