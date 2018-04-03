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
    
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.bg
        
        summaryView.backgroundColor = colors.buttonBg
        
        detailLabel.text = (event?.artist)! + ", " + (payment?.category)!
        
        //totalLabel.text = String((payment?.selectedSeats)!)
        totalLabel.text = "£" + String((payment?.selectedSeats)!*(payment?.price)!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goHome(_ sender: RoundButton) {
        let pageViewController = self.parent as! PageViewController
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as! ViewController
        
        pageViewController.pages[1] = homeViewController
         pageViewController.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    

}
