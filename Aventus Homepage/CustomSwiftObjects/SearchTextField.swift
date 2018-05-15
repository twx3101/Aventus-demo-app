//
//  SearchTextField.swift
//  
//
//  Created by Krongsiriwat, Krantharat on 05/04/2018.
//

import UIKit


// Used in AVTBaseViewController (HomeViewController, EventViewController, SeatViewController)
class SearchTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    init(frame: CGRect, arg1: CGFloat, arg2: String) {
        super.init(frame: frame)
        self.layer.cornerRadius = arg1

    }
    
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func sharedInit(){
        
        self.placeholder = "Search for Events ..."

        self.isEnabled = true
        self.isUserInteractionEnabled = true
        self.allowsEditingTextAttributes = true
        
        //Border
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 1.2
        self.layer.borderColor = colors.textFieldBorder.cgColor
        self.clipsToBounds = true
        
        //Background
        self.backgroundColor = colors.textFieldBg
        
        textColor = colors.textFieldText
        font = UIFont(name: "Sarabun", size: 24)
        
    }
    
}

