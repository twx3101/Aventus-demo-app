//
//  PaymentViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var nameTextField: DetailTextField!
    
    @IBOutlet weak var cardNoTextField: DetailTextField!
    
    @IBOutlet weak var expiryTextField: DetailTextField!
    
    @IBOutlet weak var cvvTextField: DetailTextField!
    
    
    var payment: Payment?
    
    var count: Int = 0
    
    var total: Int = 0
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PaymentTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PaymentTableViewCell else{
            fatalError("The dequeued cell is not an instance of PaymentTableViewCell.")
        }
        if indexPath.row < (count - 1) {
            
            cell.categoryLabel.text = payment?.categories[indexPath.row]
            cell.unitLabel.text = String((payment?.selectedSeats[indexPath.row])!)
            cell.priceLabel.text = String((payment?.price[indexPath.row])!)

            let sub = ((payment?.selectedSeats[indexPath.row])!*(payment?.price[indexPath.row])!)
            
            cell.subTotalLabel.text = String(sub)
            
            total = total + sub
            
            
        }
        else{
            cell.categoryLabel.text = ""
            cell.unitLabel.text = ""
            cell.priceLabel.text = ""
            cell.subTotalLabel.text = String(total)
        }
        
        //cell.backgroundColor = colors.tableBg
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = nil
        cell.contentView.backgroundColor = colors.tableBg
        cell.contentView.layer.borderWidth = 5.0
        cell.contentView.layer.borderColor = colors.bg.cgColor
        cell.contentView.layer.cornerRadius = 15.0
        
        cell.separatorInset = UIEdgeInsetsMake(20, 20, 20, 20);
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = colors.bg.cgColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConfirmSegue" {
            
            let detailViewController = segue.destination as! ConfirmationViewController
            
            detailViewController.payment = payment
            
        }
        
        /*if nameTextField.text != "" {
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "ConfirmSegue", sender: self)
            }
        }*/
    }
    
    func confirmPayment() {
        self.performSegue(withIdentifier: "ConfirmSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.bg
        tableView.backgroundColor = colors.bg
        
        
        if let p = payment?.selectedSeats.count {
            count = p + 1
        }
        
        //self.performSegue(withIdentifier: "ConfirmSegue", sender: self)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(confirmPayment), name: NSNotification.Name(rawValue: "ConfirmSegue"), object: nil)
        //count = (payment?.selectedSeats.count)! + 1
        
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
    @IBAction func confirmButton(_ sender: UIButton) {
        if nameTextField.text != "" && cardNoTextField.text != "" && expiryTextField.text != "" && cvvTextField.text != "" {
            self.performSegue(withIdentifier: "ConfirmSegue", sender: self)
        }
        else {
            warningLabel.text = "Please fill out the form."
        }
    }
    
}
