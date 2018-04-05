//
//  PaymentViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var nameTextField: DetailTextField!
    
    @IBOutlet weak var cardNoTextField: DetailTextField!
    
    @IBOutlet weak var expiryTextField: DetailTextField!
    
    @IBOutlet weak var cvvTextField: DetailTextField!
    
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var event: Event?
    
    var payment: Payment?
    
    var count: Int = 0
    
    var total: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.bg

        summaryView.backgroundColor = colors.buttonBg
        
        //artistPhoto.image = 

        detailLabel.text = (event?.artist)! + ", " + (payment?.category)!
        
        //totalLabel.text = String((payment?.selectedSeats)!)
        totalLabel.text = "£" + String((payment?.selectedSeats)!*(payment?.price)!)
        

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
    @IBAction func confirmButton(_ sender: UIButton) {
        if nameTextField.text != "" && cardNoTextField.text != "" && expiryTextField.text != "" && cvvTextField.text != "" {
            let pageViewController = self.parent as! PageViewController
            
            let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmationViewController
            
            detailViewController.event = event
            
            detailViewController.payment = payment
            
            pageViewController.pages[5] = detailViewController
            
            pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
            
        }
        else {
            warningLabel.text = "Please fill out the form."
        }
    }
    
}
