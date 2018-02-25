//
//  RoundButton.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 25/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class RoundButton: UIButton{
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
        layer.backgroundColor = colors.round.cgColor
        
        layer.cornerRadius = frame.height/2
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        clipsToBounds = true

    }
    

}
