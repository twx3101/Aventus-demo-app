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
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmSegue" {
            
            let detailViewController = segue.destination as! ConfirmationViewController
            
            detailViewController.payment = payment
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        count = (payment?.selectedSeats.count)! + 1
        
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
