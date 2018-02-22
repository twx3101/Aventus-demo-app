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
    
    var location: String
    
    var datetime: String
    
    var description: String?
    
    var photo: UIImage?
    
    var seating: Seating
    
    var time: String
    
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
    
    
    init?(artist: String, location: String, datetime: String, description: String?, photo: UIImage?, seating: Seating, time: String){
        
        guard !artist.isEmpty && !location.isEmpty && !datetime.isEmpty else{
            return nil
        }
        
        self.artist = artist
        self.location = location
        self.datetime = datetime
        self.description = description
        self.photo = photo
        self.time = time
        
        self.seating = seating
    }
   
    
}
