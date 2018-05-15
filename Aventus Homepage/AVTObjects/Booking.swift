//
//  File.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import Foundation

// Needs to convert to NSCode so that it can be stored locally
class Booking: NSObject, NSCoding{
    
    var bookingId: String?
    
    var eventId: String?
    
    var eventArtist: String?
    
    var eventLocation: String?
    
    var eventDatetime: String?
    
    var eventVenue: String?
    
    var category: String?
    
    var noTickets: String?
    
    var expanded: String?
    
    
    func encode(with aCoder: NSCoder) {
        
        if let bid = self.bookingId {
            aCoder.encode(bid, forKey: "bookingId")
        }
        
        if let id = self.eventId {
            aCoder.encode(id, forKey: "eventId")
        }
        
        if let artist = self.eventArtist {
            aCoder.encode(artist, forKey: "eventArtist")
        }
        
        if let location = self.eventLocation {
            aCoder.encode(location, forKey: "eventLocation")
        }
        
        if let datetime = self.eventDatetime {
            aCoder.encode(datetime, forKey: "eventDatetime")
        }
        
        if let venue = self.eventVenue {
            aCoder.encode(venue, forKey: "eventVenue")
        }
        
        if let cat = self.category {
            aCoder.encode(cat, forKey: "category")
        }
        
        if let tickets = self.noTickets {
            aCoder.encode(tickets, forKey: "noTickets")
        }
        
        if let e = self.expanded {
            aCoder.encode(e, forKey: "expanded")
        }
    }
    
    required init?(coder decoder: NSCoder) {
        
        if let bid = decoder.decodeObject(forKey: "bookingId") as? String {
            self.bookingId = bid
        }
        
        if let id = decoder.decodeObject(forKey: "eventId") as? String {
            self.eventId = id
        }
        
        if let artist = decoder.decodeObject(forKey: "eventArtist") as? String{
            self.eventArtist = artist
        }
        
        if let location = decoder.decodeObject(forKey: "eventLocation") as? String{
            self.eventLocation = location
        }
        
        if let datetime = decoder.decodeObject(forKey: "eventDatetime") as? String{
            self.eventDatetime = datetime
        }
        
        if let venue = decoder.decodeObject(forKey: "eventVenue") as? String {
            self.eventVenue = venue
        }
        
        if let cat = decoder.decodeObject(forKey: "category") as? String {
            self.category = cat
        }
        
        if let t = decoder.decodeObject(forKey: "noTickets") as? String {
            self.noTickets = t
        }
        
        if let e = decoder.decodeObject(forKey: "expanded") as? String {
            self.expanded = e
        }
        

    }
    
    convenience init(event: Event, payment: Payment) {
        self.init()
        self.bookingId = "dddddd"
        self.eventId = event.event_ID
        self.eventArtist = event.artist
        self.eventLocation = event.location
        self.eventDatetime = event.datetime
        self.eventVenue = event.venue
        self.category = payment.category
        self.noTickets = String(payment.selectedSeats)
        
        self.expanded = "0"
    }
    
    override init() {
    }
    

    
    
}

