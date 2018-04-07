//
//  SearchTextField.swift
//  
//
//  Created by Krongsiriwat, Krantharat on 05/04/2018.
//

import UIKit

class SearchTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit(){
        //Border
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 1.2
        self.layer.borderColor = colors.textFieldBorder.cgColor
        
        self.clipsToBounds = true
        
        //Background
        self.backgroundColor = colors.textFieldBg
        
        textColor = colors.textFieldText
        //textColor = UIColor.yellow
        font = UIFont(name: "Sarabun", size: 24)
        //Text
        
        //self.textColor = colors.textFieldText
        //self.textAlignment = NSTextAlignment.center
    }
    
}

