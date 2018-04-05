//
//  colorHelper.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 25/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

// Define global variables
struct colors{
    
    static var whiteCol: UInt32 = 0xFFFFFF
    static var purpleCol: UInt32 = 0x1E0E2B
    static var greenCol: UInt32 = 0xA6D80C
    static var pinkCol: UInt32 = 0xDD1A88
    static var neonBlueCol: UInt32 = 0x4C2DB0
    static var greyCol: UInt32 = 0xEAEAEC
    static var darkGreyCol: UInt32 =  0x878696
    
    
    // background color
    //static var bg = UIColorFromHex(rgbValue: purpleCol, alpha: 1)
    
    static var bg = UIColorFromHex(rgbValue: greyCol, alpha: 1)
    
    static var greyBg = UIColorFromHex(rgbValue: greyCol, alpha: 1)
    
    
    // table background color
    static var tableBg = UIColorFromHex(rgbValue: 0xACA2B2, alpha: 1)
    
    // table header text color
    static var headerText = UIColorFromHex(rgbValue: greenCol, alpha: 1)
    //Header 2 seating and cat
    static var headerTwoText = UIColorFromHex(rgbValue: neonBlueCol, alpha: 1)
    
    // table header background color
    static var headerBg = UIColorFromHex(rgbValue: 0x1E0E2B, alpha: 1)
    
    // table body text color
    //static var bodyText = UIColorFromHex(rgbValue: 0xe11693, alpha: 1)
    //static var bodyText = UIColorFromHex(rgbValue: 0x1f0f34, alpha: 1)
    static var bodyText = UIColorFromHex(rgbValue: whiteCol, alpha: 1)
    
    //border
    static var border = UIColorFromHex(rgbValue: pinkCol, alpha: 1)
    
    // utterance text
    static var utterText = UIColorFromHex(rgbValue: pinkCol, alpha: 1)
    
    // warning text
    static var warningText = UIColorFromHex(rgbValue: 0xff4d4d, alpha: 1)
    
    

    // textfiled color
    // static var textFieldPlaceholder = UIColorFromHex(rgbValue: 0xb8a8c1, alpha: 1)
    
    static var textFieldPlaceholder = UIColorFromHex(rgbValue: whiteCol, alpha: 1)
    
    static var textFieldText = UIColorFromHex(rgbValue: purpleCol, alpha: 1)
    
    //static var textFieldBg = UIColorFromHex(rgbValue: 0xd1ced4, alpha: 1)
    
    static var textFieldBg = UIColorFromHex(rgbValue: whiteCol, alpha: 1)
    
    // static var textFieldBorder = UIColorFromHex(rgbValue: 0xACA2B2, alpha: 1)
    static var textFieldBorder = UIColorFromHex(rgbValue: neonBlueCol, alpha: 1)
    
    
    
    // button background color
    // static var buttonBg = UIColorFromHex(rgbValue: 0xACA2B2, alpha: 1)
    static var buttonBg = UIColorFromHex(rgbValue: greyCol, alpha: 1)
    
    // button text
    static var buttonText = UIColorFromHex(rgbValue: whiteCol, alpha: 1)

}


func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

