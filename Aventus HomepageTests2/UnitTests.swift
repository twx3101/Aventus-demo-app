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
    var price : PaymentViewController!
    var home : HomeViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstSearch(){
        
        home = HomeViewController()
        let a = handlingContext()
        home.viewDidLoad()
        
        let searchtext = "Show me London"
        
        home.handle(text: searchtext)
        
        let context = ["task" : "Navigate", "artist" : "Rihanna", "musicGenre" : "pop", "location" : "London", "venue" : "O2"]
        a.parseData(context: context)
        let seat = ["task" : "Navigate", "numTickets" : "2", "priceComprison" : "<", "seatArea" : "A", "amount" : "20"]
        a.parseData(context: seat)
        
        let date =  ["day" : 1, "month" : 12, "year" : 2018]
        let date4 = ["task" : "Navigate" , "end_datetime" : date] as [String : Any]
        a.parseData(context: date4)
 
        let date2 = ["task" : "Navigate" , "start_datetime" : date] as [String : Any]
        a.parseData(context: date2)
    }
        
    
    func testTicketPriceComputed(){
        price = PaymentViewController()
        let price2 = Payment(category: "A", price: 120.0, selectedSeats: 2)
      

        price.payment = price2

        let sub = (price2.price) *  Double((price2.selectedSeats))

        if (sub != 240.0){
           XCTFail()
       }

    }

    
    func testhelpPage(){
        
      /*let help = HelpViewController()
        help.pageIndex = 1
        help.viewDidLoad()*/
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc = storyboard.instantiateViewController(withIdentifier: "helpPage") as! HelpViewController
        
        //let dummy = vc.view // force loading subviews and setting outlets
        
        vc.viewDidLoad()
    }
    
    
    func testeventPage(){
        event = EventViewController()
        event.viewDidLoad()
    }
}

