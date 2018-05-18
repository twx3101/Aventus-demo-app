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
import AVFoundation

class contextContents {
    static let shared = contextContents()
    
    var context : [AnyHashable : Any]?
    var contextContent = [String : Any]()
    var city : String?
    private init(){
    }
}

// Home Page
class HomeViewController: AVTBaseViewController{

    @IBOutlet weak var transcription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.greyBg
        self.textControl.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handlingContext.resetData()
    }
    
    // MARK: Actions
    override func micPress() {
        
        if self.isRecording {
            AudioServicesPlaySystemSound(endSound)
            CapitoController.getInstance().cancelTalking()
            helper.showAlert(message: "Done Listening")
            
        }
        else {
            AudioServicesPlaySystemSound(startSound)
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
            self.transcription.text = ""
        }
    }
}

// Context is handled differently by the page
extension HomeViewController{
    
    override func handle(response: CapitoResponse){
        if response.messageType == "WARNING"{
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
  
    // Navigate to Event page
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

        if noOfEvents.count == 1{

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
            pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
            
        //go back to event page  if there's more than 1 event to select from
        else{
            pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}


extension HomeViewController{
    
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

