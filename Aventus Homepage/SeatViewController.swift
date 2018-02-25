//
//  SeatViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let cellIdentifier = "SeatTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectedSeatPicker: UIPickerView!
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    var pickerData = [["0", "1", "2"]]
    
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
        
        
        /*let noSeatsAvail = (seating?.noSeatsAvail[indexPath.row])!
        
        if noSeatsAvail < 10 {
            for i in 0...noSeatsAvail {
                pickerData[0].append(i)
            }
        } else {
            for i in 0...10 {
                pickerData[0].append(i)
            }
        }*/

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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.bg
        
        // Add footer to hide the empty cell from the table view
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        
        seating = eventLoaded?.seating

        selectedSeatPicker.dataSource = self
        selectedSeatPicker.delegate = self
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
