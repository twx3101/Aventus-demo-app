//
//  UtterLabel.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 25/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class UtterLabel: UILabel{
    override init(frame: CGRect){
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder(){
        sharedInit()
    }
    
    func sharedInit(){
        //layer.masksToBounds = true
        //layer.cornerRadius = 5
        //clipsToBounds = true
        //layer.borderColor = colors.bg.cgColor
        //layer.borderWidth = 1.0
        textColor = colors.utterText
        
    }
    
    
}

