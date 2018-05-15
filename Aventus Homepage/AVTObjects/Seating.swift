//
//  Seating.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 15/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Seating{

    var categories: [String]
    
    var price: [Double]
    
    var noSeatsAvail: [Int]
    
    var noCategories: Int
    
    init(categories: [String], price: [Double], noSeatsAvail: [Int], noCategories: Int){
        self.categories = categories
        self.price = price
        self.noSeatsAvail = noSeatsAvail
        self.noCategories = noCategories

    }
    
}
