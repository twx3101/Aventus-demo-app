//
//  Event.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 03/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Event{
    
        
        // MARK: Properties
        var artist: String
        
        var location: String //Fake Generated City
        
        var datetime: String
    
        var formattedDate: String
        
        var seating: Seating
        
        var time: String
        
        var artist_ranking: Int
        
        var day_in_week: String
        
        var event_ID: String
        
        var event_status: String

        var venue: String
        
        var genre: String
        
        var month: String
        
        var timezone: String
    
        var bannerURL: String
        
        var weekend: String
    
        var minPrice: Double
    
        var maxPrice: Double
    
    var event_list: Int
    
    
    init?(artist: String, location: String, datetime: String, formattedDate: String, seating: Seating, time: String, artist_ranking: Int, day_in_week: String, event_ID: String, event_status: String, venue: String, genre: String, month: String, timezone: String, bannerURL: String, weekend: String, minPrice: Double, maxPrice: Double, event_list: Int){
       
            guard !artist.isEmpty && !location.isEmpty && !datetime.isEmpty else{
                return nil
            }
            
            self.artist = artist
            self.location = location
            self.datetime = datetime
            self.formattedDate = formattedDate
            self.time = time
            self.artist_ranking = artist_ranking
            self.day_in_week = day_in_week
            self.event_ID = event_ID
            self.event_status = event_status
            self.venue = venue
            self.genre = genre
            self.month = month
            self.timezone = timezone
            self.bannerURL = bannerURL
            self.weekend = weekend
            self.minPrice = minPrice
            self.maxPrice = maxPrice
            self.seating = seating
        
            self.event_list = event_list
        }
    }


