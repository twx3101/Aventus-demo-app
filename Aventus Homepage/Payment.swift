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
    
    var category: String
    
    var price: Int
    
    var selectedSeats: Int
    
    // MARK: Initialization
    
    init(category: String, price: Int, selectedSeats: Int){
        
        self.category = category
        self.price = price
        self.selectedSeats = selectedSeats
    }
    
}
