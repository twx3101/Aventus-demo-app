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
    
    // MARK: Properties
    @IBOutlet weak var utter1Label: UILabel!
    
    @IBOutlet weak var utter2Label: UILabel!
    
    @IBOutlet weak var waveFrame: UIView!
    
    @IBOutlet weak var microphone: RecordButton!
    
    @IBOutlet weak var transcription: UILabel!
    
    @IBOutlet weak var textControl: UITextField!
    
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

    // MARK: Actions
    

    @IBAction func microphonePress(_ sender: UIButton) {
        
        if self.isRecording {
            CapitoController.getInstance().cancelTalking()
            print("if")
        }
        else {
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: nil)
                self.transcription.text = ""
        }
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
    func bootstrapView(response: CapitoResponse){
        //print("bootstrapview")
        //process
        print("Response Code: %@", response.responseCode)
        print("Message Text: %@", response.message)
        print("Context: %@", response.context)
        print("Data: %@", response.data)
        
    
        //app-specific code to handle responses
        
        // go to the event page
        let pageViewController = self.parent as! PageViewController
        pageViewController.setViewControllers([pageViewController.pages[2]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.parseData(context: response.context)
    }
    
   func handle(text:String){
        self.showProcessingHUD(text: "Processing...")
        
        CapitoController.getInstance().text(self, input: text, withDialogueContext: nil)
    }
    
    func handle(response: CapitoResponse){
        //print("handle")
        if response.messageType == "WARNING"{
            //self.showErrorMessage(text: response.message)
        }
        else{
            self.bootstrapView(response: response)
        }
    }
    
    func parseData(context: [AnyHashable : Any]){
        
        if let task = context["task"] as? String{
            if task == "Navigate"{
                //TODO
                print("Success!")
                handleNavigate(context: context)
            }
            else if task == "BuyTicket"{
                //TODO
            }
            else if task == "SelectSeat"{
                //TODO
            }
            else if task == "NavigateStatic"{
                //TODO
            }
        }
        else{
            //handle nil data
            print("NIL Data")
        }
    }
    
    func handleNavigate(context: [AnyHashable : Any]){
        var contextContents = [String: Any]()
//        artist: String
        if let artist = context["artist"] as? String{
            contextContents["artist"] = artist

        }
//        location: String
        if let location = context["location"] as?  String{
            contextContents["location"] = location
        }
        
        //        venue: String
        if let venue = context["venue"] as? String{
            contextContents["venue"] = venue
        }
        
        //        genre: String
        if let genre = context["musicGenre"] as? String{
            contextContents["genre"] = genre
        }
        
        // handling time: AnyHashable("start_datetime")
        if let datetime = context["start_datetime"] as? [String : AnyObject]{
            let day = datetime["day"] as? Int
            let month = datetime["month"] as? Int
            let year = datetime["year"] as? Int
            
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let c = DateComponents(year: year, month: month, day: day )
            
            contextContents["start_date"] = cal.date(from: c)!
        }
        if let end_datetime = context["end_datetime"] as? [String: Int]{
            //if start_date is empty, set date to current time
            
            if contextContents.index(forKey: "start_datetime") == nil {
                contextContents["start_date"] = setCurrentDate()
            }
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            
            let end_day = end_datetime["day"]
            let end_month = end_datetime["month"]
            let end_year = end_datetime["year"]
            
            let d = DateComponents(year: end_year, month: end_month, day: end_day)
            
            contextContents["end_date"] = cal.date(from: d)
            
        }
        
        var daysToAdd = 0
        var monthsToAdd = 0
        var yearsToAdd = 0
        
        // Find events a period of time from current time
        if var end_week = context["end_week"] as? String{
         
            if end_week[end_week.startIndex] == "+"{
                end_week.remove(at: end_week.startIndex)
                let addWeekBy = Int(end_week)
                
                daysToAdd += addWeekBy! * 7
                
            }
        }
        
        if var end_day = context["end_day"] as? String{
            if end_day[end_day.startIndex] == "+"{
                end_day.remove(at: end_day.startIndex)
                let addDayBy = Int(end_day)
                
                daysToAdd = daysToAdd + addDayBy!
                
            }
        }
            
        if var end_month = context["end_month"] as? String{
            if end_month[end_month.startIndex] == "+"{
                end_month.remove(at: end_month.startIndex)
                let addMonthBy = Int(end_month)
                    
                monthsToAdd = monthsToAdd + addMonthBy!
                    
            }
        }
        
        if (daysToAdd != 0 || monthsToAdd != 0 || yearsToAdd != 0){
            // if no start date is set, set date to current day
            if contextContents.index(forKey: "start_datetime") == nil  {
                contextContents["start_date"] = setCurrentDate()
            }
            // set end date to current date + no. of days to add
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            let d = DateComponents(year: yearsToAdd, month: monthsToAdd, day: daysToAdd)
        
            let futureDate = cal.date(byAdding: d, to: start_date)
        
            contextContents["end_date"] = futureDate
        }
        // if there is no end_date, then set end_Date to the next day
        if contextContents.index(forKey: "end_date") == nil && contextContents.index(forKey: "start_date") != nil{
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            let d = DateComponents(day: 1)
            
            let futureDate = cal.date(byAdding: d, to: start_date)
            
            contextContents["end_date"] = futureDate
        }
        
        
        //handling time of day and hour
        if let dayPart = context["dayPart"] as? String{
            if contextContents.index(forKey: "start_datetime") == nil  {
                contextContents["start_date"] = setCurrentDate()
            }
            
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            var d = DateComponents(hour: 0)
            var e = DateComponents(hour: 0)
            if dayPart == "Day"{
                d.hour = 6
                e.hour = 12
            }
            else if dayPart == "Afternoon"{
                d.hour = 12
                e.hour = 18
            }
            else if dayPart == "Night"{
                d.hour = 18
                e.hour = 24
            }
            let futureDate = cal.date(byAdding: d, to: start_date)
            let endDate = cal.date(byAdding: e, to: start_date)
            
            contextContents["start_date"] = futureDate
            contextContents["end_date"] = endDate
        }
        

        // handle time to day, month, seating for price, currency, time for day Part, comparison is contextual, need to handle end_hour
        let pageViewController = self.parent as! PageViewController
        let eventViewController = pageViewController.pages[2] as! EventViewController
        eventViewController.isFiltering = true
        eventViewController.filteredItems = contextContents
            
    }
    
    func setCurrentDate() -> Date{
        let current_date = Date()
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "GMT")!
        
        var c = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: current_date)
        
        c.hour = 0
        c.minute = 0
        c.second = 0
        return cal.date(from: c)!
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
