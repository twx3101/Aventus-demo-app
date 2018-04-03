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
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var ticketPicker: UIPickerView!
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    var pickerData: [[String]] = [[String]]()
    
    var categoriesData: [String] = [String]()
    
    var priceData: [String] = [String]()
    
    var ticketData: [String] = [String]()
    
    var selectedCategory: String = ""
    
    var selectedPrice: Int = 0
    
    var selectedTicket: Int = 0
    
    let pickerWidth = 100
    
    let pickerHeight = 80
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag==0) {
            return categoriesData.count
        } else {
            return ticketData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var view: UIView
        
        if(pickerView.tag==0){
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth*2, height: pickerHeight))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth*2, height: 30))
            topLabel.text = categoriesData[row]
            topLabel.textColor = .white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
            view.addSubview(topLabel)
            
            let bottomLabel = UILabel(frame: CGRect(x: 0, y: pickerHeight/2, width: pickerWidth*2, height: 30 ))
            bottomLabel.text = "£" + priceData[row]
            bottomLabel.textColor = .white
            bottomLabel.textAlignment = .center
            bottomLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
            view.addSubview(bottomLabel)
            
        } else {
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 40))
            //let topLabel = UILabel()
            topLabel.center.x = view.center.x
            topLabel.center.y = view.center.y
            topLabel.text = ticketData[row]
            topLabel.textColor = .white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFontWeightThin)
            view.addSubview(topLabel)
            
        }
        
        /*view.layer.cornerRadius = 15.0
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 1.0
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = true*/
        
        //view.backgroundColor = colors.buttonBg
        
        return view
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag==0) {
            selectedCategory = categoriesData[row]
            selectedPrice = Int(priceData[row])!
            
            //print(selectedCategory)
        } else {
            selectedTicket = Int(ticketData[row])!
            //print(ticketData[row])
        }

    }

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
        
        seating = (eventLoaded?.seating) as! Seating
        
        categoriesData = (seating!.categories)
        
        let noCategories = (seating!.noCategories)
        
        for i in 0..<noCategories {
            priceData.append(String(seating!.price[i]))
        }
        let noSeats = 6
        for i in 0..<noSeats {
            ticketData.append(String(i))
        }
        
        selectedCategory = categoriesData[0]
        selectedPrice = Int(priceData[0])!
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        ticketPicker.delegate = self
        ticketPicker.dataSource = self
  

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func showLayoutButton(_ sender: RoundButton) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "seatLayoutPopUp") as! SeatPopUpViewController
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func purchaseButton(_ sender: RoundButton) {
        
        if(selectedTicket==0) {
            return
        }
        
        let pageViewController = self.parent as! PageViewController
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
        
        detailViewController.event = eventLoaded
        
        detailViewController.payment = Payment(category: selectedCategory, price: selectedPrice, selectedSeats: selectedTicket)
        
        pageViewController.pages[4] = detailViewController
        
        pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}
