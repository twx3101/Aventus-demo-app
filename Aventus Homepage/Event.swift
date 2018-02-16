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
    
    // MARK: Initialization
    init?(json: [String: Any]) {
        guard let jsonartist = json["Artist"] as? String else{
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
    }
    
    
    init?(artist: String, location: String, datetime: String, description: String?, photo: UIImage?){
        
        guard !artist.isEmpty && !location.isEmpty && !datetime.isEmpty else{
            return nil
        }
        
        self.artist = artist
        self.location = location
        self.datetime = datetime
        
        self.description = description
        self.photo = photo
    }
   
    
}
