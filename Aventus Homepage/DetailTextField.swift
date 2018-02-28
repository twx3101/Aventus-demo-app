//
//  TextField.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 26/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class DetailTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit(){
        //Border
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 1.5
        self.layer.borderColor = colors.textFieldBorder.cgColor
        
        //Background
        self.backgroundColor = colors.textFieldBg
        
        //Text
        //self.textColor = UIColor.black
        //self.textAlignment = NSTextAlignment.center
    }
    
}
