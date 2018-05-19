//
//  ConfirmationViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 15/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController{
    
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var ticketButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper.setBackground(view: self.view, image: "confirmBg")
        
        self.view.bringSubview(toFront: homeButton)
        self.view.bringSubview(toFront: ticketButton)
        
        homeButton.isEnabled = true
        homeButton.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // Navigate to Home page
    @IBAction func goHome(_ sender: UIButton) {
        let pageViewController = self.parent as! PageViewController
        
        let homeViewController = pageViewController.pages[1] as! HomeViewController
        homeViewController.home = false
        pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    // Navigat to Ticket page
    @IBAction func goViewTicket(_ sender: UIButton) {
        
        let pageViewController = self.parent as! PageViewController
        
        //let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomePage") as! HomeViewController
        
        let homeViewController = pageViewController.pages[1] as! HomeViewController
        
        homeViewController.home = false
        pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        homeViewController.navTicket()
    }
    
}
