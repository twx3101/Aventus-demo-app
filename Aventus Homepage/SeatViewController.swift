//
//  SeatViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import Alamofire

class SeatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var locationDateTimeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    
    @IBOutlet weak var categoriesPicker: UIPickerView!
    
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    var pickerData: [[String]] = [[String]]()
    
    var categoriesData: [String] = [String]()
    
    var ticketData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag==0) {
            return categoriesData.count
        } else {
            return ticketData.count
        }
        
    }*/
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*if(pickerView.tag == 0) {
            return categoriesData[row]
        } else {
            return ticketData[row]
        }*/
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        //var titleData: String

        let titleData = pickerData[component][row]
        //let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.black])
        let myTitle = NSAttributedString(string: titleData)
        pickerLabel.attributedText = myTitle
        //color  and center the label's background
        //let hue = CGFloat(row)/CGFloat(categoriesData.count)
        pickerLabel.backgroundColor = colors.buttonBg
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
 
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    /*func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0) {
            var noSeats = seating?.noSeatsAvail[row] as! Int
            print(noSeats)
            if(noSeats > 10) {
                noSeats = 10
            }
            print(noSeats)
            ticketData = ["No of tickets"]
            for i in 0..<noSeats {
                ticketData.append(String(i))
            }
            print(ticketData)
        }
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.bg
        
        artistLabel.text = eventLoaded?.artist
        locationDateTimeLabel.text = eventLoaded?.location
        descriptionLabel.text = (eventLoaded?.datetime)! + " " + (eventLoaded?.time)!
        
       Alamofire.request((eventLoaded?.imageURL)!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value{
                self.artistPhoto.image = image
            }
        }
        
        seating = eventLoaded?.seating
        
        categoriesData = (seating?.categories)!
        let noSeats = 11
        for i in 0..<noSeats {
            ticketData.append(String(i))
        }

        pickerData.append(categoriesData)
        pickerData.append(ticketData)

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

    @IBAction func showLayoutButton(_ sender: RoundButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "seatLayoutPopUp") as! SeatPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func purchaseButton(_ sender: RoundButton) {
        
        let pageViewController = self.parent as! PageViewController

        let detailViewController = pageViewController.pages[4] as! PaymentViewController
            
            /*var categories = [String]()
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
            
            detailViewController.payment = Payment(categories: (seating?.categories)!, price: (seating?.price)!, selectedSeats: seats)*/
        pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}
