//
//  headerLabel.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 26/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel{
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

        textColor = colors.headerText
        
    }
    
    
}


