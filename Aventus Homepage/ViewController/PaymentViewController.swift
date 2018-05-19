//
//  PaymentViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import FirebaseDatabase


// Payment page
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
        
        helper.setBackground(view: self.view, image: "paymentBg")
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        
        // Move the textbox up when users type in the information
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaymentViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Set the text to be displayed in the summary

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
    
    // When users begin editing
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // When users finish editing
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // the height for the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return self.summaryItems.count-1
    }
    
    // How the cell is displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cellIdentifier = "SummaryTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SummaryTableViewCell
        
        cell.detailLabel.font = UIFont(name : "Sarabun",size : 24)
        
        cell.backgroundColor = .clear
    
        // Display the total amount differently
        if( indexPath.row == self.summaryItems.count-2){
            let labelFont = UIFont(name: "Sarabun-Bold", size: 25)
            let color = UIColor.white
            let attributes :Dictionary = [NSFontAttributeName : labelFont, NSForegroundColorAttributeName : color] as [String : Any]
            
            // Create attributed string
            let attrString = NSAttributedString(string: self.summaryItems[indexPath.row+1], attributes:attributes)
            cell.detailRightLabel?.attributedText = attrString
            cell.detailLabel?.text = self.summaryItems[indexPath.row]
            cell.detailLabel?.textAlignment = .left
            cell.detailLabel?.textColor = UIColor.white
        }else{
            cell.detailLabel?.text = self.summaryItems[indexPath.row]
            cell.detailLabel?.textAlignment = .left
            cell.detailRightLabel?.text = ""
            cell.detailLabel?.textColor = UIColor.white

        }
      
        return cell
    }
 
    // When users click confirm button
    @IBAction func confirmButton(_ sender: UIButton) {
        
        // Proceed when the users complete the form 
        if nameTextField.text != "" && cardNoTextField.text != "" && expiryTextField.text != "" && cvvTextField.text != "" {
            
            let pageViewController = self.parent as! PageViewController
            
            
                // Retrieve data from the users' phone, append the current booking to them and update the data
                var userBookings: [Booking] = helper.retrieveDataFromKey(key: "Bookings")
                let currentBooking = Booking(event: event!, payment: payment!)
                //userBookings.append(currentBooking)
                userBookings.insert(currentBooking, at: 0)
                helper.saveDataForKey(key: "Bookings", data: userBookings)
            
            
            
                // Update the number of tickets available in Firebase database
                var seats: Int
                seats = (payment?.selectedSeats)!
                let id = String((self.event?.event_list)! - 1)
                let category = convert()
                let seat = self.event?.seating
                var no = seat?.noSeatsAvail[seatCategory]
                no = (no)! - seats
            
                seat?.noSeatsAvail[seatCategory] = no!

               // let ref = Database.database().reference().root.child(id).updateChildValues([category:no])
            
                // Navigate to Confirm page
                let popOverVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmationViewController
            
                pageViewController.pages[5] = popOverVC
                
                pageViewController.setViewControllers([popOverVC], direction: UIPageViewControllerNavigationDirection.forward , animated: true, completion: nil)
        }
        else {
            warningLabel.text = "Please fill out the form."
        }
    }
    
    func convert() -> String{
        var stringToReturn : String
        
        switch self.payment?.category{
        case "A"?:
            stringToReturn = "Category 4: "
            seatCategory = 1
        case "B"?:
            stringToReturn = "Category 3: "
            seatCategory = 2
        case "C"?:
            stringToReturn = "Category 2: "
            seatCategory = 3
        case "D"?:
            stringToReturn = "Category 1: "
            seatCategory = 4
        case "Standing area"?:
            stringToReturn = "Category 5: "
            seatCategory = 0
        default:
            stringToReturn = "Category 5: "
            seatCategory = 0
        }
        stringToReturn += "Number of seat available"
        
        return stringToReturn
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
