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
    
    var noSeatsAvail: [Int]
    
    var noCategories: Int
 
    
    
    // MARK: Initialization
    
    init(categories: [String], noSeatsAvail: [Int], noCategories: Int){
        
        self.categories = categories
        self.noSeatsAvail = noSeatsAvail
        self.noCategories = noCategories
    }
    
}
