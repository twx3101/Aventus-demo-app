//
//  ProfileViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var ticketView: UIView!
    
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func indexChanged(_ sender: Any) {
        

        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            UIView.animate(withDuration: 0.25, animations: {
                
                self.profileView.alpha = 1
                self.ticketView.alpha = 0
                self.settingView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.25, animations: {
                self.profileView.alpha = 0
                self.ticketView.alpha = 1
                self.settingView.alpha = 0
            })
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.profileView.alpha = 0
                self.ticketView.alpha = 0
                self.settingView.alpha = 1
            })
        default:
            break
        }
        
        segmentedControl.changeSelectedIndex(to: segmentedControl.selectedSegmentIndex)
        //segmentedControl.configure()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = colors.bg
    
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        //self.profileView.alpha = 1
        //self.ticketView.alpha = 0
        //self.settingView.alpha = 0
        
         segmentedControl.selectedSegmentIndex = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
