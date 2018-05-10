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
import BRYXBanner


class contextContents {
    static let shared = contextContents()
    
    var context : [AnyHashable : Any]?
    var contextContent = [String : Any]()
    
    private init(){
    }
}

//TODO: add busy microphone button, add transcription textbox, add Errorlabels, add textDelegate

class ViewController: UIViewController, UITextFieldDelegate{
    
    lazy var readyMic: UIImage = {
        return UIImage(named: "icons8-microphone-96")!
    }()
    
    lazy var pressedMic: UIImage = {
        return UIImage(named: "microphone_on")!
    }()
    
    var isRecording: Bool = false
    
    var controller: CapitoController?
    
    var popup: UIView!
    
    var alert:UIAlertController!
    
    // MARK: Properties
    @IBOutlet weak var utter1Label: UILabel!
    
    @IBOutlet weak var utter2Label: UILabel!
    
    @IBOutlet weak var waveFrame: UIView!
    
    @IBOutlet weak var microphone: RecordButton!
    
    @IBOutlet weak var transcription: UILabel!
    
    @IBOutlet weak var textControl: UITextField!
    
    @IBOutlet weak var resetBut: UIButton!
    //var contextContent : [AnyHashable : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.bg
        self.waveFrame.backgroundColor = colors.bg
        //genWave()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.textControl.delegate = self
    }
    
    func genWave() {
        let range: CGFloat = 20
        let centerY = waveFrame.frame.height / 2
        let steps = 200
        let stepX = waveFrame.frame.width / CGFloat(steps)
        
        let originX = waveFrame.frame.origin.x
        let originY = waveFrame.frame.origin.y
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: originX, y: originY+centerY))
        
        for i in 0...steps {
            let x = CGFloat(i) * stepX + originX
            let y = (sin((Double(i) * 0.08)) * Double(range)) + Double(centerY) + Double(originY)
            path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
        }
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.view.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = colors.buttonBg.cgColor
        //pathLayer.strokeColor = UIColor.white.cgColor
        pathLayer.fillColor = nil
        //pathLayer.lineWidth = 2.0
        //pathLayer.lineJoin = kCALineJoinBevel
        
        //Add the layer to your view's layer
        self.view.layer.addSublayer(pathLayer)
        
        let duration: CFTimeInterval = 10
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0
        end.toValue = 1.0175
        end.beginTime = 0
        end.duration = duration * 0.75
        end.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        //end.fillMode = kCAFillModeForwards

        let begin = CABasicAnimation(keyPath: "strokeStart")
        begin.fromValue = 0
        begin.toValue = 1.0175
        begin.beginTime = duration * 0.15
        begin.duration = duration * 0.85
        begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        //begin.fillMode = kCAFillModeBackwards
        
        let group = CAAnimationGroup()
        group.animations = [end, begin]

        pathLayer.add(group, forKey: "move")
        
    }
    
    func showAlert() {
        
        let banner = Banner(title: "Aventus", subtitle: "Done Listening", image: UIImage(named: "Icon"), backgroundColor: colors.neonblueBg)
        
        banner.position = BannerPosition.bottom
        banner.dismissesOnTap = true
        
        banner.show(duration: 2.0)

    }
    
    // MARK: Actions
    
    @IBAction func help(_ sender: UIButton) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "HelpPage") as! HelpViewController
        
        let pageViewController = self.parent as! PageViewController
        
        detailViewController.pageIndex = pageViewController.pages.index(of: self)
        
        present(detailViewController, animated: true, completion: nil)
    }
    
    @IBAction func microphonePress(_ sender: UIButton) {
        
        if self.isRecording {
            CapitoController.getInstance().cancelTalking()
            print("if")
            
            showAlert()
            
        }
        else {
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
                self.transcription.text = ""
        }
    }
    
    @IBAction func resetContext(_ sender: Any) {
        contextContents.shared.context = nil
        transcription.text = "Resetted!"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = self.textControl.text{
            print("Sending Text event:\(text)")
            self.handle(text: text)
            
        }
        textField.text = ""
        return true
    }
   
}

extension ViewController{
    
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
           
            
            if let task = response.context["task"] as? String{
                
                if task == "Navigate"{
                    handleNavigate()
                }
                if task == "BuyTicket" || task == "BuyTickets"{
                    handleBuyTickets()
                }
                
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
    func handleBuyTickets(){
        
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
        if let category = contextContents.shared.contextContent["ticketType"] as? String{
            
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
extension ViewController{
    
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

extension ViewController: SpeechDelegate{
    
    func speechControllerDidBeginRecording() {
        self.isRecording = true
        //change microphone to show busy recording
        self.microphone.setImage(pressedMic, for: .normal)
    }
    
    func speechControllerDidFinishRecording() {
        self.isRecording = false
        self.microphone.setImage(readyMic, for: .normal)
    }
    
    func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        self.showProcessingHUD(text: "Processing...")
        self.transcription.text = String(format: "\"%@\"", transcription.firstResult().replacingOccurrences(of: " | ", with: " "))
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
 extension ViewController: TextDelegate{
    func textControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
    self.handle(response: response)
    }
 
    func textControllerDidFinishWithError(_ error: Error!){
        self.hideProcessingHUD()
        self.showError(error)
    }
 }
