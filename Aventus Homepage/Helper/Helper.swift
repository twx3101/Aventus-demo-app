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
    
    static func showAlert(message: String) {
        
        let banner = Banner(title: "Aventus", subtitle: message, image: UIImage(named: "Icon"), backgroundColor: colors.neonblueBg)
        banner.dismissesOnTap = true
        banner.show(duration: 4.0)
        
    }
    
    static func retrieveDataFromKey(key: String) -> [Booking] {
        
        let ud = UserDefaults.standard
        var bookings: [Booking] = []
        
        if let dataRetrieved = ud.object(forKey: key) as? NSData{
            bookings = (NSKeyedUnarchiver.unarchiveObject(with: dataRetrieved as Data) as? [Booking])!
        } else {
            bookings = []
        }
        //print(bookings[0].noTickets)
        return bookings
    }
    
    static func saveDataForKey(key: String, data: [Booking]) {
        
        let ud = UserDefaults.standard
        
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: data)
        ud.set(dataToSave, forKey: key)
        ud.synchronize()
    }
    
    static func setBackground(view: UIView, image: String) {
        let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height) )
        bgImageView.image = UIImage(named: image)
        
        view.insertSubview(bgImageView, at: 0)
    }
    
}
