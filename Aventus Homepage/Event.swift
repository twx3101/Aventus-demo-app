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
