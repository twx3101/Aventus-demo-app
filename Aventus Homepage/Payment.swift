//
//  Payment.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 17/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Payment{
    
    // MARK: Properties
    
    var categories: [String]
    
    var price: [Int]
    
    var selectedSeats: [Int]
    
    // MARK: Initialization
    
    init(categories: [String], price: [Int], selectedSeats: [Int]){
        
        self.categories = categories
        self.price = price
        self.selectedSeats = selectedSeats
    }
    
}
