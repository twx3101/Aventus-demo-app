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
    
    static func helpTips(){
        let roll = arc4random_uniform(11)
        
        switch roll{
        case 0:
            helper.showAlert(message: "Tip: Return to the home page to restart a new search")
        case 1:
            helper.showAlert(message: "A 2007 study found that music, especially classical music, helps plants grow faster")
        case 2:
            helper.showAlert(message: "Tip: I can help filter through genre, artist, location, price and time")
        case 3:
            helper.showAlert(message: "Tip: There is a help page in the menu bar to help you speak to me!")
        case 4:
            helper.showAlert(message: "Classy Shakespeare quote: \"If music be the food of love, play on\"")
        case 5:
            helper.showAlert(message: "Tip: I have event genres: pop, rock, heavy metal, rap, hip-hop, classical, electronic dance")
        case 6:
            helper.showAlert(message: "Tip: You can search for events near you")
        case 7:
            helper.showAlert(message: "Tip: If you're shy to speak to me we can text ;) Just use the chat bar")
        case 8:
            helper.showAlert(message: "Tip: You can search for tickets less than a certain amount or within a price range")
        case 9:
            helper.showAlert(message: "Tip: You can search by location: London, Bristol, Liverpool, Manchester and Birmingham")
        case 10:
            helper.showAlert(message: "In retail stores slow music is played to keep you shopping and spend more. In restaurants fast music is played to speed up turnaround")
        default:
            print("No tips for today")
        }
        
    }
    
    
    // The banner appears when users finish their speech
    static func showAlert(message: String) {
        
        let banner = Banner(title: "AV:", subtitle: message, image: UIImage(named: "Icon"), backgroundColor: colors.neonblueBg)
        banner.dismissesOnTap = true
        banner.show(duration: 3.9)
        
    }
    
    // retrieve booking users have by key
    static func retrieveDataFromKey(key: String) -> [Booking] {
        
        let ud = UserDefaults.standard
        var bookings: [Booking] = []
        
        if let dataRetrieved = ud.object(forKey: key) as? NSData{
            bookings = (NSKeyedUnarchiver.unarchiveObject(with: dataRetrieved as Data) as? [Booking])!
        } else {
            bookings = []
        }
        return bookings
    }
    
    // save data to users' phone by key
    static func saveDataForKey(key: String, data: [Booking]) {
        let ud = UserDefaults.standard
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: data)
        ud.set(dataToSave, forKey: key)
        ud.synchronize()
    }
    
    // set background image to the view
    static func setBackground(view: UIView, image: String) {
        let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height) )
        bgImageView.image = UIImage(named: image)
        
        view.insertSubview(bgImageView, at: 0)
    }
    
}
