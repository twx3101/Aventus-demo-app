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
    static var bg = UIColorFromHex(rgbValue: 0x1E0E2B, alpha: 1)
    static var text = UIColorFromHex(rgbValue: 0xA6D80C, alpha: 1)
    static var rect = UIColorFromHex(rgbValue: 0xDCDCDC, alpha: 1)
    static var round = UIColorFromHex(rgbValue: 0xACA2B2, alpha: 1)

}


func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}
