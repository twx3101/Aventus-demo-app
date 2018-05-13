//
//  ConfirmationViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 15/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController{
    
    var event: Event?
    
    var payment: Payment?
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var ticketButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper.setBackground(view: self.view, image: "confirmBg")
        
        self.view.bringSubview(toFront: homeButton)
        self.view.bringSubview(toFront: ticketButton)
        
        homeButton.isEnabled = true
        homeButton.isUserInteractionEnabled = true
        
        //confirmView.backgroundColor = colors.darkpurpleBg
        
        /*labelConfirm.lineBreakMode = .byWordWrapping
        labelConfirm.numberOfLines = 0
        labelConfirm.textAlignment = .center
        labelConfirm.textColor = colors.headerText
        
        confirmViewTicketButton.titleLabel?.font = UIFont(name : "Sarabun-Bold" , size: 24)
        confirmViewTicketButton.setTitleColor(colors.whiteText,for: UIControlState.normal)
        
        confirmViewTicketButton.layer.borderWidth = 0.6
        confirmViewTicketButton.layer.backgroundColor = (colors.headerThreeText).cgColor
        confirmViewTicketButton.layer.cornerRadius = 15
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/
        
    }
    
    func showAnimate()
    {
        /*self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func goHome(_ sender: UIButton) {
        print("hello")
        let pageViewController = self.parent as! PageViewController
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomePage") as! HomeViewController
        
        pageViewController.pages[1] = homeViewController
        pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    @IBAction func goViewTicket(_ sender: UIButton) {
        
        let pageViewController = self.parent as! PageViewController
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomePage") as! HomeViewController
        
        pageViewController.pages[1] = homeViewController
        pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        homeViewController.navTicket()
    }
    
}
