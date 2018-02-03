//
//  Aventus_HomepageTests.swift
//  Aventus HomepageTests
//
//  Created by Krongsiriwat, Krantharat on 01/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import XCTest
@testable import Aventus_Homepage

class Aventus_HomepageTests: XCTestCase {
    
    // MARK: Event Class Tests
    
    // Confirm that the Event initializer returns an Event object when passed valid parameters.
    func testEventInitSucceeds(){
        let sampleEvent = Event.init(artist: "Selena", location: "London", datetime: "today", description: "first time", photo: nil)
        XCTAssertNotNil(sampleEvent)
        
        let sampleEvent2 = Event.init(artist: "Drake", location: "London", datetime: "today", description: "first time", photo: nil)
        XCTAssertNotNil(sampleEvent2)
    }
    
    func testEventInitFails(){
        let sampleEvent = Event.init(artist: "", location: "London", datetime: "today", description: "first time", photo: nil)
        XCTAssertNil(sampleEvent)
    
        let sampleEvent2 = Event.init(artist: "Drake", location: "London", datetime: "", description: "first time", photo: nil)
        XCTAssertNil(sampleEvent2)
    }
}
