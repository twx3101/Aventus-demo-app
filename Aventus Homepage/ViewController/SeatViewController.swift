//
//  SeatViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import Alamofire
import CapitoSpeechKit
import MBProgressHUD
import AVFoundation

class SeatViewController: AVTBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource{

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
    
    @IBOutlet weak var micButton: UIButton!
    
    @IBOutlet weak var warningLabel: WarningLabel!
    
    lazy var readyMic: UIImage = {
        return UIImage(named: "icons8-microphone-96")!
    }()
    lazy var pressedMic: UIImage = {
        return UIImage(named: "microphone_on")!
    }()
    var isRecording : Bool = false
    
    var menuTap: UITapGestureRecognizer!
    
    var eventLoaded: Event?
    
    var seating: Seating?
    
    var seatCategory: Int = 0
    
    var categoriesData: [String] = [String]()
    
    var priceData: [String] = [String]()
    
    var ticketData: [String] = [String]()
    
    var selectedCategory: String = ""
    
    var selectedPrice: Double = 0
    
    var selectedTicket: Int = 0
    
    var category: Int = 0
    
    let pickerWidth = 100
    
    let pickerHeight = 80
    
    let controller = CapitoController.getInstance()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
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
        } else {
            selectedTicket = Int(ticketData[row])!
        }

    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.greyBg
        
        eventView.layer.cornerRadius = 5.0
        eventView.clipsToBounds = true
        
        //pickerView.layer.cornerRadius = 15.0
        //pickerView.clipsToBounds = true
        //pickerView.layer.borderWidth = 1.2
        //pickerView.layer.borderColor = (colors.border).cgColor
        pickerView.layer.backgroundColor = (UIColor.white.withAlphaComponent(0.95)).cgColor
        
        pickerView.layer.cornerRadius = 5.0
        
//        pickerView.layer.shadowColor = UIColor.black.cgColor
//        pickerView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        pickerView.layer.masksToBounds = false
//        pickerView.layer.shadowRadius = 2.0
//        pickerView.layer.shadowOpacity = 1.0
//        pickerView.clipsToBounds = true

        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        ticketPicker.delegate = self
        ticketPicker.dataSource = self
        
        
        layoutButton.setTitleColor(colors.headerTwoText, for: UIControlState.normal)
        
        categoryLabel.textColor = colors.headerTwoText
        ticketLabel.textColor = colors.headerTwoText

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
        categoryPicker.showsSelectionIndicator = false
        ticketPicker.selectRow(selectedTicket, inComponent: 0, animated: false)
        ticketPicker.showsSelectionIndicator = false
        
        categoryPicker.subviews[1].isHidden = true
        categoryPicker.subviews[2].isHidden = true

        
        menuButton.addTarget(self, action: #selector(showMenu), for:    .touchUpInside)
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showMenu() {
        
        showMenuBase()
        
        menuTap = UITapGestureRecognizer(target: self, action: #selector(hideMenu(_:)))
        view.addGestureRecognizer(menuTap)
        
        micButton.isEnabled = false
        
        
    }
    
    @objc func hideMenu(_ tap: UITapGestureRecognizer) {
        
        hideMenuBase()
        
        view.removeGestureRecognizer(menuTap)
        micButton.isEnabled = true
        
        
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
            warningLabel.text = "Please select the number of tickets."
            return
        }
        
        convertStringCatToInt()
        let seat = self.eventLoaded?.seating
        var no = seat?.noSeatsAvail[seatCategory]
        no = (no)! - selectedTicket

        if no! < 0{
            warningLabel.text = "There are no seats available. Please select another category."
            return
        }
            
        
        let pageViewController = self.parent as! PageViewController
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
        
        detailViewController.event = eventLoaded
        
        detailViewController.payment = Payment(category: selectedCategory, price: selectedPrice, selectedSeats: selectedTicket)
        
        pageViewController.pages[4] = detailViewController
        
        pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func convertStringCatToInt() {
    
        switch self.selectedCategory{
        case "A":
            seatCategory = 1
        case "B":
            seatCategory = 2
        case "C":
            seatCategory = 3
        case "D":
            seatCategory = 4
        case "Standing area":
            seatCategory = 0
        default:
            seatCategory = 0
        }

    }
    
    
    @IBAction func micPress(_ sender: UIButton) {
        let startSound: SystemSoundID = 1110
        let endSound : SystemSoundID = 1111
        
        if self.isRecording {
            controller?.cancelTalking()
            print("if")
            AudioServicesPlaySystemSound(endSound)
            
            helper.showAlert(message: "Done Listening")
        }
        else {
            controller?.push(toTalk: self, withDialogueContext: contextContents.shared.context)
            AudioServicesPlaySystemSound(startSound)
        }

    }
}

extension SeatViewController{
    func handle(text:String){
        self.showProcessingHUD(text: "Processing...")
        
        CapitoController.getInstance().text(self, input: text, withDialogueContext: contextContents.shared.context)
    }
    
    func handle(response: CapitoResponse){
        //print("handle")
        if response.messageType == "WARNING"{
            //self.showErrorMessage(text: response.message)
        }
        else{
            handlingContext().bootstrapView(response: response)
            if let task = response.semanticOutput["task"] as? String{
                //self.isFiltering = true
                //self.filteredItems = contextContents.shared.contextContent
                //self.filterContentofEvents(contextContent: self.filteredItems)
                //self.collectionView.reloadData()
                
                if task == "BuyTicket" || task == "BuyTickets"{
                    handleBuyTickets()
                }
                else if task == "Navigate"{
                    handleNavigate()
                }
            }
        }
    }
    
    func handleBuyTickets(){
        var categoryNum : Int?
        var number: Int?
        
        let pageViewController = self.parent as! PageViewController
        
        //let noOfEvents = self.filteredEvents
        
        //instatiated ticket buying page
        //let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        //pageViewController.pages[3] = detailViewController
        
        if let numTickets = contextContents.shared.contextContent["numTickets"] as? String{
            
            number = Int(numTickets)
            self.selectedTicket = number!
            
        }
        if let category = contextContents.shared.contextContent["seatArea"] as? String{
            
            switch category{
            case "A":
                categoryNum = 1
            case "B":
                categoryNum = 2
            case "C":
                categoryNum = 3
            case "D":
                categoryNum = 4
            case "Standing":
                categoryNum = 0
            default:
                categoryNum = 0
            }
            self.category = categoryNum!
        }
        
        
            
        if number != nil && categoryNum != nil{
            let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
            
            pageViewController.pages[4] = paymentViewController
            paymentViewController.event = self.eventLoaded
            let selectedCategories = self.categoriesData[categoryNum!]
            let selectedPrice = self.priceData[categoryNum!]
            let price = Double(selectedPrice)
            
            paymentViewController.payment = Payment(category: selectedCategories, price: price!, selectedSeats: number!)
            pageViewController.setViewControllers([paymentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        else if number != nil{
            
            //tell user to select number
        }
        else if categoryNum != nil{
            //tell user to select category
        }
    }
    
    func handleNavigate(){
        var nextViewController : EventViewController
        
        let pageViewController = self.parent as! PageViewController
        
        if pageViewController.instantiated[2] == false{
            nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventPage") as! EventViewController
            
            pageViewController.pages[2] = nextViewController
            pageViewController.instantiated[2] = true
        }
        else{
            nextViewController = pageViewController.pages[2] as! EventViewController
            nextViewController.isFiltering = true
            nextViewController.filteredItems = contextContents.shared.contextContent
            nextViewController.filterContentofEvents(contextContent: nextViewController.filteredItems)
        }
        nextViewController.isFiltering = true
        nextViewController.filteredItems = contextContents.shared.contextContent
        
        pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)    }
    
}


extension SeatViewController{
    
    func showProcessingHUD(text: String){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.minShowTime = 1.0
        hud.label.text = "Processing"
        hud.detailsLabel.text = text
    }
    func hideProcessingHUD(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}

extension SeatViewController: SpeechDelegate{
    
    func speechControllerDidBeginRecording() {
        self.isRecording = true
        //change microphone to show busy recording
        self.micButton.setImage(pressedMic, for: .normal)
    }
    
    func speechControllerDidFinishRecording() {
        self.isRecording = false
        self.micButton.setImage(readyMic, for: .normal)
    }
    
    func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        self.showProcessingHUD(text: "Processing...")
    }
    
    func speechControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    func speechControllerDidFinishWithError(_ error: Error!) {
        self.hideProcessingHUD()
        self.showError(error)
    }
}

extension SeatViewController: TextDelegate{
    func textControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    func textControllerDidFinishWithError(_ error: Error!){
        self.hideProcessingHUD()
        self.showError(error)
    }
}
