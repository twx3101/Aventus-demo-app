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
    
    @IBOutlet weak var categoryLabel: HeaderLabel!
    
    @IBOutlet weak var ticketLabel: HeaderLabel!
    
    @IBOutlet weak var locationDateTimeLabel: UILabel!
    
    @IBOutlet weak var layoutButton: UIButton!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var ticketPicker: UIPickerView!

    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var pickerView: UIView!
    
    @IBOutlet weak var labelView: UIView!
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    var categoriesData: [String] = [String]()
    
    var priceData: [String] = [String]()
    
    var ticketData: [String] = [String]()
    
    var selectedCategory: String = ""
    
    var selectedPrice: Double = 0
    
    var selectedTicket: Int = 0
    
    var category: Int = 0
    
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
        
        let labelColor = UIColor.black
        
        if(pickerView.tag==0){
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth*2, height: pickerHeight))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth*2, height: 30))
            topLabel.text = categoriesData[row]
            topLabel.textColor = labelColor
            
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Sarabun", size: 25)
            view.addSubview(topLabel)
            
            let bottomLabel = UILabel(frame: CGRect(x: 0, y: pickerHeight/2, width: pickerWidth*2, height: 30 ))
            bottomLabel.text = "£" + priceData[row]
            bottomLabel.textColor = labelColor
            bottomLabel.textAlignment = .center
            bottomLabel.font = UIFont(name: "Sarabun", size: 25)
            view.addSubview(bottomLabel)
            
        } else {
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight))
            
            let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 40))
            topLabel.center.x = view.center.x
            topLabel.center.y = view.center.y
            topLabel.text = ticketData[row]
            topLabel.textColor = labelColor
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Sarabun", size: 36)
            view.addSubview(topLabel)
            
        }
        

        
        return view
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag==0) {
            selectedCategory = categoriesData[row]
            selectedPrice = Double(priceData[row])!
            
            //print(selectedCategory)
        } else {
            selectedTicket = Int(ticketData[row])!
            //print(ticketData[row])
        }

    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.bg
        
        eventView.layer.cornerRadius = 15.0
        eventView.clipsToBounds = true
        
        //labelView.isHidden = true
        
        pickerView.layer.cornerRadius = 15.0
        pickerView.clipsToBounds = true
        //pickerView.backgroundColor = colors.greyBg
        pickerView.layer.borderWidth = 1.2
        pickerView.layer.borderColor = (colors.border).cgColor
        //pickerView.transform = CGAffineTransformMak
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        ticketPicker.delegate = self
        ticketPicker.dataSource = self
        
        
        //layoutButton.layer.backgroundColor = (colors.headerTwoText).cgColor
        layoutButton.setTitleColor(colors.headerTwoText, for: UIControlState.normal)
        
        categoryLabel.textColor = colors.headerTwoText
        ticketLabel.textColor = colors.headerTwoText
       // artistLabel.text = (eventLoaded?.artist)! + " - " + (eventLoaded?.location)!
        //locationDateTimeLabel.text = (eventLoaded?.datetime)! + ", " + (eventLoaded?.time)!
        
        //labelView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        let txtLabel = ((eventLoaded?.artist)?.uppercased())! + " " + (eventLoaded?.location)!
        
        let mutableString = NSMutableAttributedString(string: txtLabel)
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: colors.bodyText, range: NSRange(location: 0, length: txtLabel.count))
        
        mutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Nexa Light", size: 21) as Any, range: NSRange(location: 0, length: (eventLoaded?.artist.count)!))
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: colors.headerText, range: NSRange(location: 0, length: (eventLoaded?.artist.count)!))
        
        
        artistLabel.attributedText = mutableString
        
        locationDateTimeLabel.text = (eventLoaded?.formattedDate)! + ", " + (eventLoaded?.time)!
        locationDateTimeLabel.textColor = colors.bodyText
 
        Alamofire.request((eventLoaded?.bannerURL)!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value{
                self.artistPhoto.image = image
            }
        }
        
        seating = (eventLoaded?.seating) as! Seating
        
        categoriesData = (seating!.categories)
        
        let noCategories = (seating!.noCategories)
        
        for i in 0..<noCategories {
            priceData.append(String(format:"%.02f", seating!.price[i]))
        }
        let noSeats = 6
        for i in 0..<noSeats {
            ticketData.append(String(i))
        }
        
        selectedCategory = categoriesData[category]
        selectedPrice = Double(priceData[category])!
        
        categoryPicker.selectRow(category, inComponent: 0, animated: false)
        ticketPicker.selectRow(selectedTicket, inComponent: 0, animated: false)

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
        
        /*let popOverVC = storyboard?.instantiateViewController(withIdentifier: "seatLayoutPopUp") as! SeatPopUpViewController
        
        present(popOverVC, animated: true, completion: nil)*/
        
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
