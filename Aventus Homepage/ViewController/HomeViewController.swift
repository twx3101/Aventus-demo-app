//
//  ViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 01/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import CapitoSpeechKit
import MBProgressHUD
//import AVFoundation


class contextContents {
    static let shared = contextContents()
    
    var context : [AnyHashable : Any]?
    var contextContent = [String : Any]()
    
    private init(){
    }
}

//TODO: add busy microphone button, add transcription textbox, add Errorlabels, add textDelegate

class HomeViewController: AVTBaseViewController{
   // let startSound : SystemSoundID = 1110
  //  let endSound : SystemSoundID = 1111

    //var controller: CapitoController?
    
    var popup: UIView!
    
    var alert:UIAlertController!
    
    // MARK: Properties
    @IBOutlet weak var utter1Label: UILabel!
    
    @IBOutlet weak var utter2Label: UILabel!
    
    @IBOutlet weak var microphone: RecordButton!
    
    @IBOutlet weak var transcription: UILabel!
    
    @IBOutlet weak var resetBut: UIButton!
    
    var menuTap: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.greyBg
        
        self.textControl.delegate = self
        
        menuButton.addTarget(self, action: #selector(showMenu), for:    .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handlingContext.resetData()
    }

    
    // MARK: Actions


    @objc func hideMenu(_ tap: UITapGestureRecognizer) {
        
        hideMenuBase()
        
        view.removeGestureRecognizer(menuTap)
        micButton.isEnabled = true
        
        
    }
    
    func showMenu() {
        
        showMenuBase()
        
        menuTap = UITapGestureRecognizer(target: self, action: #selector(hideMenu(_:)))
        view.addGestureRecognizer(menuTap)
        
        micButton.isEnabled = false
        
    }
    
    
    /*@IBAction func microphonePress(_ sender: UIButton) {
        
        if self.isRecording {
           // AudioServicesPlaySystemSound(endSound)
            CapitoController.getInstance().cancelTalking()
            print("if")
            
            helper.showAlert(message: "Done Listening")
            
        }
        else {
           // AudioServicesPlaySystemSound(startSound)
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
                self.transcription.text = ""
        }
    }*/
    
    override func micPress() {
        
        print ("pressed")
        if self.isRecording {
            // AudioServicesPlaySystemSound(endSound)
            CapitoController.getInstance().cancelTalking()
            print("if")
            
            helper.showAlert(message: "Done Listening")
            
        }
        else {
            // AudioServicesPlaySystemSound(startSound)
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
            self.transcription.text = ""
        }
    }
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = self.textControl.text{
            print("Sending Text event:\(text)")
            self.handle(text: text)
            
        }
        textField.text = ""
        return true
    }*/
   
}

extension HomeViewController{
    
   /*override func handle(text:String){
        self.showProcessingHUD(text: "Processing...")
        
        CapitoController.getInstance().text(self, input: text, withDialogueContext: contextContents.shared.context)
    }*/
    
    override func handle(response: CapitoResponse){
        //print("handle")
        if response.messageType == "WARNING"{
            //self.showErrorMessage(text: response.message)
        }
        else{
            
           
            
            if let task = response.semanticOutput["task"] as? String{
                handlingContext().bootstrapView(response: response)
                if task == "NavigateStatic"{
                    navHelp()
                }
                if task == "Navigate"{
                    handleNavigate()
                }
                if task == "BuyTicket" || task == "BuyTickets"{
                    handleBuyTickets()
                }
                
            }
            else{
                helper.showAlert(message: "Sorry, I couldn't understand that")
            }
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
        
        pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    override func handleBuyTickets(){
        
        var categoryNum : Int?
        var number: Int?
        var nextViewController : EventViewController
        let pageViewController = self.parent as! PageViewController
        
        
        if pageViewController.instantiated[2] == false{
            nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventPage") as! EventViewController
            
            pageViewController.pages[2] = nextViewController
            pageViewController.instantiated[2] = true
            
            nextViewController.isFiltering = true
            nextViewController.filteredItems = contextContents.shared.contextContent
        }
        else{
            nextViewController = pageViewController.pages[2] as! EventViewController
            nextViewController.isFiltering = true
            nextViewController.filteredItems = contextContents.shared.contextContent
            nextViewController.filterContentofEvents(contextContent: nextViewController.filteredItems)
        }
        
        let noOfEvents = nextViewController.filteredEvents
        
        //instatiated ticket buying page
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        pageViewController.pages[3] = detailViewController
        
        if let numTickets = contextContents.shared.contextContent["numTickets"] as? String{
            
            number = Int(numTickets)
            detailViewController.selectedTicket = number!
           
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
            detailViewController.category = categoryNum!
        }
        
        print("HELLO2")
      
        
       
        if noOfEvents.count == 1{
            print("Hello3", noOfEvents.count)
            
            if number != nil && categoryNum != nil{
                let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
                
                pageViewController.pages[4] = paymentViewController
                paymentViewController.event = detailViewController.eventLoaded
                let selectedCategories = detailViewController.categoriesData[categoryNum!]
                let selectedPrice = detailViewController.priceData[categoryNum!]
                let price = Double(selectedPrice)
                
                
                paymentViewController.payment = Payment(category: selectedCategories, price: price!, selectedSeats: number!)
            }
            else if number != nil{
                
                detailViewController.eventLoaded = nextViewController.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
            else if categoryNum != nil{
                 detailViewController.eventLoaded = nextViewController.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
        }
        else if noOfEvents.count == 0{
            //TODO
            pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
            
            //go back to event page  if there's more than 1 event to select from
        else{
            pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}

//errors
/*extension HomeViewController{
    
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
        //print(error.localizedDescription)
    }
    
}*/

extension HomeViewController{
    
    /*func speechControllerDidBeginRecording() {
        self.isRecording = true
        //change microphone to show busy recording
        self.microphone.setImage(pressedMic, for: .normal)
    }
    
    func speechControllerDidFinishRecording() {
        self.isRecording = false
        self.microphone.setImage(readyMic, for: .normal)
    }*/
    
    override func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        self.showProcessingHUD(text: "Processing...")
        self.transcription.text = String(format: "\"%@\"", transcription.firstResult().replacingOccurrences(of: " | ", with: " "))
    }
    
    override func speechControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    override func speechControllerDidFinishWithError(_ error: Error!) {
        self.hideProcessingHUD()
        self.showError(error)
    }
}

/*
 extension ViewController: UISearchBarDelegate {
    func searchButtonPressed(_ searchBar: UISearchBar){
        self.textControlBar.resignFirstResponder()
 
        if let text = searchBar.text{
            print("Sending text event: \(text)")
            self.onTextControlClick(nil)
            self.handle(text: text)
        }
    }
 }
*/
 /*extension HomeViewController: TextDelegate{
    func textControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
    self.handle(response: response)
    }
 
    func textControllerDidFinishWithError(_ error: Error!){
        self.hideProcessingHUD()
        self.showError(error)
    }
 }
*/
