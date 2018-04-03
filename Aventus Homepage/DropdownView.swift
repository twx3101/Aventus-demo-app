//
//  DropdownView.swift
//  
//
//  Created by Krongsiriwat, Krantharat on 03/04/2018.
//

import UIKit

class DropdownView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    func sharedInit(){
        
        self.backgroundColor = colors.buttonBg
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.clipsToBounds = true
    }

}
