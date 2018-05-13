//
//  Ticket.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import Foundation

class Ticket: NSObject, NSCoding {
    
    var id: Int?
    
    var category: String?
    
    override init() {
        
    }
    
    init(_id: Int?, _category: String?) {
        id = _id
        category = _category
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let ticketId = aDecoder.decodeObject(forKey: "ticketId") as? Int {
            self.id = ticketId
        }
        
        if let ticketCat = aDecoder.decodeObject(forKey: "ticketCategory") as? String {
            self.category = ticketCat
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let ticketId = self.id {
            aCoder.encode(ticketId, forKey: "ticketId")
        }
        
        if let ticketCat = self.category {
            aCoder.encode(ticketCat, forKey: "ticketCategory")
        }
    }
    
    
}
