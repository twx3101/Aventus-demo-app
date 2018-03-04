//
//  Aventus_Database_Tests.swift
//  Aventus Database Tests
//
//  Created by Weixiong Tay on 04/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import XCTest

class Aventus_Database_Tests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sessionUnderTest = nil
        super.tearDown()
        
        
    }
    
    func testDatabaseLoad() {
        
        let imageURL = URL(string: "https://images.sk-static.com/images/media/img/col6/20160826-174436-629129.jpg")
        
        
        let dataTask = sessionUnderTest.dataTask(with: imageURL!) { data, response, error in
            
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                
                }else {
                XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
    }
    
   
}
