//
//  EventImageView.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventView: UIView {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sharedInit(){
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        
    }
    
}

