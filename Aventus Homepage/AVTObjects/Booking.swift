//
//  File.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import Foundation

class Booking: NSObject, NSCoding{
    
    
    // MARK: Properties
    
    var eventId: String?
    
    var eventArtist: String?
    
    var eventLocation: String?
    
    var eventDatetime: String?
    
    var eventVenue: String?
    
    var tickets: [Ticket]?
    
    
    func encode(with aCoder: NSCoder) {
        
        if let id = self.eventId {
            aCoder.encode(id, forKey: "eventId")
        }
        
        if let artist = self.eventArtist {
            aCoder.encode(artist, forKey: "eventArtist")
        }
        
        if let location = self.eventArtist {
            aCoder.encode(location, forKey: "eventLocation")
        }
        
        if let datetime = self.eventArtist {
            aCoder.encode(datetime, forKey: "eventDatetime")
        }
        
        if let venue = self.eventArtist {
            aCoder.encode(venue, forKey: "eventVenue")
        }
        
        if let tickets = self.tickets {
            aCoder.encode(tickets, forKey: "tickets")
        }
    }
    
    required init?(coder decoder: NSCoder) {
        if let id = decoder.decodeObject(forKey: "eventId") as? String{
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
        
        if let venue = decoder.decodeObject(forKey: "eventVenue") as? String{
            self.eventVenue = venue
        }
        
        if let t = decoder.decodeObject(forKey: "tickets") as? [Ticket] {
            self.tickets = t
        }
    }
    
    convenience init(event: Event, tickets: [Ticket]) {
        self.init()
        self.eventId = event.event_ID
        self.eventArtist = event.artist
        self.eventLocation = event.location
        self.eventDatetime = event.datetime
        self.eventVenue = event.venue
        self.tickets = tickets
    }
    
    override init() {
    }
    

    
    
}

