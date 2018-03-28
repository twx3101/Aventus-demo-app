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
        genWave()
        
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
        //process
        print("Response Code: %@", response.responseCode)
        print("Message Text: %@", response.message)
        print("Context: %@", response.context)
        print("Data: %@", response.data)
        
    
        //app-specific code to handle responses
        self.parseData(context: response.context)
    }
    
   func handle(text:String){
        self.showProcessingHUD(text: "Processing...")
        
        CapitoController.getInstance().text(self, input: text, withDialogueContext: nil)
    }
    
    func handle(response: CapitoResponse){
        if response.messageType == "WARNING"{
            //self.showErrorMessage(text: response.message)
        }
        else{
            self.bootstrapView(response: response)
        }
    }
    
    func parseData(context: [AnyHashable : Any]){
        
        if let task = context["Task"] as? String{
            if task == "Navigate"{
                //TODO
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
        }
    }
    
    func handleNavigate(context: [AnyHashable : Any]){
//        artist: String
//        print(context[AnyHashable("artist")]?)
//        location: String
//
//        datetime: String
//
//        seating: Seating
//
//        time: String
//
//        day_in_week: String
//
//        venue: String
//
//        genre: String
//
//        month: String
//
//        city: String
//
//        weekend: String
        
        // handle time to day, month, seating for price, currency, time for day Part, comparison is contextual
        // end hour, end week , endday is range of dates
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
