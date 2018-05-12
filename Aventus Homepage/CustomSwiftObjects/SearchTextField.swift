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
        
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    init(frame: CGRect, arg1: CGFloat, arg2: String) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = arg1
        print(arg2)
        print("Instantiated")
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
        
        //textControl.backgroundColor = colors.white
        
        self.placeholder = "Search for Events ..."
        //textControl.borderStyle = UITextBorderStyle.roundedRect
        //textControl.autocorrectionType = UITextAutocorrectionType.no
        //textControl.keyboardType = UIKeyboardType.default
        //textControl.returnKeyType = UIReturnKeyType.done
        //textControl.clearButtonMode = UITextFieldViewMode.whileEditing;
        //textControl.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
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
        //Text
        
    }
    
}

