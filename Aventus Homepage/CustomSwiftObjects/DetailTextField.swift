//
//  TextField.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 26/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

// Used to show the textbox in Payment page
class DetailTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit(){
        //Border
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 0.5
        self.layer.borderColor = colors.textFieldBorder.cgColor
        
        //Background
        self.backgroundColor = colors.textFieldBg
        self.font = UIFont(name: "Sarabun", size: 24)
        
    }
    
}
