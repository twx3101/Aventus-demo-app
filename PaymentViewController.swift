//
//  PaymentViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var nameTextField: DetailTextField!
    
    @IBOutlet weak var cardNoTextField: DetailTextField!
    
    @IBOutlet weak var expiryTextField: DetailTextField!
    
    @IBOutlet weak var cvvTextField: DetailTextField!
    
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var summaryTableView: UITableView!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var event: Event?

    var payment: Payment?
    
    var count: Int = 0
    
    var total: Int = 0
    
    var seatCategory: Int = 0
 
    var summaryItems = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.bg
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self

        summaryView.backgroundColor = colors.buttonBg
        
        let thickness: CGFloat = 0.5
        let borderColor = (colors.border).cgColor
        
        let topBorder = CALayer()
        topBorder.backgroundColor = borderColor
        topBorder.frame = CGRect(x: 0, y:0, width: summaryView.frame.width, height: thickness)
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = borderColor
        bottomBorder.frame = CGRect(x: 0, y: summaryView.frame.height, width: summaryView.frame.width, height: thickness)
        
        summaryView.layer.addSublayer(topBorder)
        summaryView.layer.addSublayer(bottomBorder)
        
        let text_total = String(format:"%.02f",Double((payment?.selectedSeats)!)*(payment?.price)!)

        let text_1line = (event?.artist)!
        let text_12line = (event?.venue)! + ", " + (event?.location)!
        let text_2line = (event?.datetime)! + "   " + (event?.time)!

        
        let price: String = String(format:"%.02f", (payment?.price)!)
        let selectedSeats: String = String((payment?.selectedSeats)!)
        
        var text_cat = ""
        if (payment?.category == "Standing area"){
            text_cat = (payment?.category)!
        }else{
            text_cat = "Category " + (payment?.category)!
        }
        
        let text_3line = text_cat + " (£" + price + ")" + " X " + selectedSeats
        let text_4line = "Total: £" + text_total

        summaryItems = [text_1line,text_12line, text_2line, text_3line, text_4line]
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return self.summaryItems.count-1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellIdentifier = "SummaryTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SummaryTableViewCell
        
        cell.detailLabel.font = UIFont(name : "Sarabun",size : 24)
        
        cell.backgroundColor = colors.bg
        

        if( indexPath.row == self.summaryItems.count-2){
            let labelFont = UIFont(name: "Sarabun-Bold", size: 25)
            let attributes :Dictionary = [NSFontAttributeName : labelFont]
            
            // Create attributed string
            let attrString = NSAttributedString(string: self.summaryItems[indexPath.row+1], attributes:attributes)
            cell.detailRightLabel?.attributedText = attrString
            cell.detailLabel?.text = self.summaryItems[indexPath.row]
            cell.detailLabel?.textAlignment = .left
        }else{
            cell.detailLabel?.text = self.summaryItems[indexPath.row]
            cell.detailLabel?.textAlignment = .left
            cell.detailRightLabel?.text = ""
        
        }
      
        
        return cell
    }
 
    
    @IBAction func confirmButton(_ sender: UIButton) {
        if nameTextField.text != "" && cardNoTextField.text != "" && expiryTextField.text != "" && cvvTextField.text != "" {
            /*let pageViewController = self.parent as! PageViewController
            
            let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmationViewController
            
            detailViewController.event = event
            
            detailViewController.payment = payment
            
            pageViewController.pages[5] = detailViewController
            
            pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)*/
            
         
            let pageViewController = self.parent as! PageViewController
          
            let id = String((self.event?.event_list)! - 1)
            let category = convert()
            let seat = self.event?.seating
            var no = seat?.noSeatsAvail[seatCategory]
            no = (no)! - (payment?.selectedSeats)!
            
            if no! < 0{
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "seatLayoutPopUp") as! SeatPopUpViewController
                
                self.addChildViewController(popOverVC)
                popOverVC.view.frame = self.view.frame
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParentViewController: self)
                
            
            }else{
            
                
                
            let popOverVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmationViewController
                
            popOverVC.event = event
            popOverVC.payment = payment
            seat?.noSeatsAvail[seatCategory] = no!
            
            
            let ref = Database.database().reference().root.child(id).updateChildValues([category:no])
            pageViewController.pages[5] = popOverVC
            
            pageViewController.setViewControllers([popOverVC], direction: UIPageViewControllerNavigationDirection.forward , animated: true, completion: nil)
            }
            
            /*let popOverVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmationViewController
            
            popOverVC.event = event
            popOverVC.payment = payment
            
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)*/
            
            
            
        }
        else {
            warningLabel.text = "Please fill out the form."
        }
    }
    
    func convert() -> String{
        var stringToReturn : String
        
        switch self.payment?.category{
            case "A":
            stringToReturn = "Category 4: "
            seatCategory = 4
            case "B":
            stringToReturn = "Category 3: "
            seatCategory = 3
            case "C":
            stringToReturn = "Category 2: "
            seatCategory = 2
            case "D":
            stringToReturn = "Category 1: "
            seatCategory = 1
        case "Standing area":
            stringToReturn = "Category 5: "
            seatCategory = 0
        default:
            stringToReturn = "Category 5: "
            seatCategory = 0
        }
        stringToReturn += "Number of seat available"
        
        return stringToReturn
    }

}
