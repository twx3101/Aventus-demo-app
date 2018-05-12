//
//  File.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class Booking{
    
    // MARK: Properties
    
    var event: Event
    
    var tickets: [Ticket] = []
    
    // MARK: Initialization
    
    init(_event: Event, _tickets: [Ticket]){
        event = _event
        tickets = _tickets
    }
    
    
    
}

