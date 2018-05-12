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
    
    @IBOutlet weak var confirmViewTicketButton: UIButton!
    
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var labelConfirm: UtterLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.bg
        
        confirmView.backgroundColor = colors.darkpurpleBg
        
        labelConfirm.lineBreakMode = .byWordWrapping
        labelConfirm.numberOfLines = 0
        labelConfirm.textAlignment = .center
        labelConfirm.textColor = colors.headerText
        
        confirmViewTicketButton.titleLabel?.font = UIFont(name : "Sarabun-Bold" , size: 24)
        confirmViewTicketButton.setTitleColor(colors.whiteText,for: UIControlState.normal)
        
        confirmViewTicketButton.layer.borderWidth = 0.6
        confirmViewTicketButton.layer.backgroundColor = (colors.headerThreeText).cgColor
        confirmViewTicketButton.layer.cornerRadius = 15
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTicket(_ sender: RoundButton) {
        let pageViewController = self.parent as! PageViewController
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomePage") as! HomeViewController
        
        pageViewController.pages[1] = homeViewController
        pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    

}
