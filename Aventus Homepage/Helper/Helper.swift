//
//  UIFunction.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import BRYXBanner

class helper {
    
    static func showAlert() {
        
        let banner = Banner(title: "Aventus", subtitle: "Done Listening", image: UIImage(named: "Icon"), backgroundColor: colors.neonblueBg)
        banner.dismissesOnTap = true
        banner.show(duration: 2.0)
        
    }
}