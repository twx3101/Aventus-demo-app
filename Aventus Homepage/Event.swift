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
        
        var description: String?
        
        var photo: UIImage?
        
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
        
        var city: String //Real City
        
        var imageURL: String
    
    var bannerURL: String
        
        var address: String
        
        var weekend: String
        
        
        
        // MARK: Initialization
        /*init?(json: [String: Any]) {
         guard let jsonartist = json["Fake Mainstream Events"] as? String else{
         return nil
         }
         self.artist = jsonartist
         guard let jsonlocation = json["Venue name"] as? String
         else{
         return nil
         }
         self.location = jsonlocation
         guard let jsondatetime  = json["Local Date"] as?
         String
         else{
         return nil
         }
         self.datetime = jsondatetime
         self.description = nil
         self.photo = nil
         //creating Seat class
         var jsonPrice = [Int]()
         
         guard let jsoncata = json["Category 1 Price"] as? String else{
         print("price error 1")
         return nil
         }
         let cata = Int(jsoncata)
         guard let jsoncatb = json["Category 2: Price"] as? String else{
         print("price error 2")
         return nil
         }
         let catb = Int(jsoncatb)
         guard let jsoncatc = json["Category 3: Price"] as? String else{
         print("price error 3")
         return nil
         }
         let catc = Int(jsoncatc)
         guard let jsoncatd = json["Category 4: Price"] as? String else{
         print("price error 4")
         return nil
         }
         let catd = Int(jsoncatd)
         guard let jsoncate = json["Category 5(standing area): Price"] as? String else{
         print("price error 5")
         return nil
         }
         let cate = Int(jsoncate)
         jsonPrice += [cata!, catb!, catc!, catd!, cate!]
         
         let seats = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "Standing"], price: jsonPrice, noSeatsAvail: [10,10,0,10,10], noCategories: jsonPrice.count)
         
         
         self.seating = seats
         
         }*/
        
    
    init?(artist: String, location: String, datetime: String, formattedDate: String, description: String?, photo: UIImage?, seating: Seating, time: String, artist_ranking: Int, day_in_week: String, event_ID: String, event_status: String, venue: String, genre: String, month: String, timezone: String, city: String, imageURL: String, bannerURL: String, address: String, weekend: String){
            
            guard !artist.isEmpty && !location.isEmpty && !datetime.isEmpty else{
                return nil
            }
            
            self.artist = artist
            self.location = location
            self.datetime = datetime
            self.formattedDate = formattedDate
            self.description = description
            self.photo = photo
            self.time = time
            self.artist_ranking = artist_ranking
            self.day_in_week = day_in_week
            self.event_ID = event_ID
            self.event_status = event_status
            self.venue = venue
            self.genre = genre
            self.month = month
            self.timezone = timezone
            self.city = city
            self.imageURL = imageURL
            self.bannerURL = bannerURL
            self.address = address
            self.weekend = weekend
            
            
            self.seating = seating
        }
    
    /*init?(artist: String, location: String, datetime: String, description: String?, photo: UIImage?, seating: Seating, time: String, artist_ranking: Int, day_in_week: String, event_ID: String, event_status: String, venue: String, genre: String, month: String, timezone: String, imageURL: String, weekend: String){
        
        guard !artist.isEmpty && !location.isEmpty && !datetime.isEmpty else{
            return nil
        }
        
        self.artist = artist
        self.location = location
        self.datetime = datetime
        self.description = description
        self.photo = photo
        self.time = time
        self.artist_ranking = artist_ranking
        self.day_in_week = day_in_week
        self.event_ID = event_ID
        self.event_status = event_status
        self.venue = venue
        self.genre = genre
        self.month = month
        self.timezone = timezone
        //self.city = city
        self.imageURL = imageURL
        //self.address = address
        self.weekend = weekend
        
        
        self.seating = seating
    }*/
        
        
    }


