//
//  Payment.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 17/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Payment{

    var category: String
    
    var price: Double
    
    var selectedSeats: Int
    
    init(category: String, price: Double, selectedSeats: Int){
        
        self.category = category
        self.price = price
        self.selectedSeats = selectedSeats
    }
    
}
