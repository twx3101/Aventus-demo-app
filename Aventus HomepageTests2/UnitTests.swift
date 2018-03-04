//
//  UnitTests.swift
//  
//
//  Created by Weixiong Tay on 04/03/2018.
//

import XCTest
@testable import Aventus_Homepage

class Aventus_HomepageTests2: XCTestCase {
    var event : EventViewController!
    var price : ConfirmationViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFiltering(){
        event = EventViewController()
        
        let searchText = "London"
        
        
        event.filteredEvents = event.events.filter({( event:Event) -> Bool in
            return event.artist.lowercased().contains(searchText.lowercased()) || event.location.lowercased().contains(searchText.lowercased())
            
            })
        for i in event.filteredEvents{
            if (!i.artist.lowercased().contains(searchText.lowercased())){
                XCTFail()
            }
            if (!i.artist.lowercased().contains(searchText.lowercased())){
                XCTFail()
            }
        }
    }
    
    func testTicketPriceComputed(){
        price = ConfirmationViewController()
        let newpay = Payment(categories: ["101"], price: [120], selectedSeats: [2])
        
        price.payment = newpay
        
        let sub = (price.payment?.price[0])! *  (price.payment?.selectedSeats[0])!
        
        if (sub != 240){
            XCTFail()
        }
        
        

    }
    
    func testCapitoSpeechsetup(){
        /*
         var controller : CapitoController
         
         controller.setupWithID("
         
         let status = CapitoController.getInstance.connect()
         if status != "kCapitoConnect_SUCCESS"{
         XCTFailt("Status Code: \(status)")
         }
         */
    }
}

