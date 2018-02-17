//
//  Seating.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 15/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Seating{
    
    // MARK: Properties
    
    var categories: [String]
    
    var no_seats_avail: [Int]
    
    var no_categaries: Int
    
    var artist: String
    
    var location: String
    
    var datetime: String
    
    var description: String?
    
    var photo: UIImage?
    
    
    
    // MARK: Initialization
    
    init(categories: [String], no_seats_avail: [Int], no_categories: Int){
        
        self.categories = categories
        self.no_seats_avail = no_seats_avail
        self.no_categaries = no_categories
    }
}
