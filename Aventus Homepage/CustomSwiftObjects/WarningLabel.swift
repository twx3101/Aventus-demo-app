//
//  WarningLabel.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit


// Warning label used in Seat and Payment page
class WarningLabel: UILabel{
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
        
        textColor = colors.warningText
        font = UIFont(name: "Sarabun", size: 22)
        
    }
    
    
}


