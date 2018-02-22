//
//  SeatViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let cellIdentifier = "SeatTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventLoaded == nil {
            return 0
        }
        else {
            return eventLoaded!.seating.noCategories
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SeatTableViewCell else{
            fatalError("The dequeued cell is not an instance of SeatTableViewCell.")
        }
        
        cell.categoryLabel.text = seating?.categories[indexPath.row]
        cell.priceLabel.text = "\(seating?.price[indexPath.row] ?? 0)"
        cell.noSeatsLabel.text = "\(seating?.noSeatsAvail[indexPath.row] ?? 0)"

        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentSegue" {
            
            let detailViewController = segue.destination as! PaymentViewController
            
            var categories = [String]()
            var seats = [Int]()
            var prices = [Int]()
        
            let section = 0
            
            for row in 0 ..< tableView.numberOfRows(inSection: section)  {
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView.cellForRow(at: indexPath)
                let seatCell = (cell as! SeatTableViewCell)
                
                if let selected = Int(seatCell.selectedSeats.text!) {
                    if selected > 0 {
                        categories.append(seatCell.categoryLabel.text!)
                        prices.append(Int(seatCell.priceLabel.text!)!)
                        seats.append(Int((cell as! SeatTableViewCell).selectedSeats.text!)!)
                    }
                }
            }
            
            detailViewController.payment = Payment(categories: (seating?.categories)!, price: (seating?.price)!, selectedSeats: seats)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seating = eventLoaded?.seating

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
    @IBAction func showLayoutButton(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "seatLayoutPopUp") as! SeatPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

}
