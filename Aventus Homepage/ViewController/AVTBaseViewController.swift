//
//  BaseViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import CapitoSpeechKit
import MBProgressHUD

class AVTBaseViewController: UIViewController, UITextFieldDelegate {
    
    var menuView: UIView = UIView()
    
    var helpButton: UIButton = UIButton(type: UIButtonType.system)
    var ticketButton: UIButton = UIButton(type: UIButtonType.system)
    
    var menuButton: UIButton = UIButton(type: UIButtonType.system)
    var chatButton: UIButton = UIButton(type: UIButtonType.system)

    var textControl: UITextField = SearchTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    var cancelButton: UIButton = UIButton(type: UIButtonType.system)
    
    var micButton: UIButton = RecordButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    lazy var readyMic: UIImage = {
        return UIImage(named: "icons8-microphone-96")!
    }()
    
    lazy var pressedMic: UIImage = {
        return UIImage(named: "microphone_on")!
    }()
    
    var menuTap: UITapGestureRecognizer!
    
    var isRecording: Bool = false
    
    var SCALE: Float!
    
    var sideMargin: Int  = 20
    var topMargin: Int = 24
    
    var buttonSize: Int = 30
    var menuButtonSize: Int = 20
    
    var textfieldHeight: Int = 30
    var textfieldWidth: Int = 0
    
    var menuWidth: Int = 120
    
    var leftItemX: Int = 0
    var rightItemX: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftItemX = sideMargin
        rightItemX = Int(self.view.frame.width) - sideMargin - buttonSize
        
        textfieldWidth = Int(self.view.frame.width) - (sideMargin*2) - buttonSize
        
        // The first view at the top of the page consists of menu button and chat button
        // This view appears when the page is first loaded
        
        menuButton.frame = CGRect(x: leftItemX + (buttonSize - menuButtonSize)/2, y: topMargin + (buttonSize - menuButtonSize)/2, width: menuButtonSize, height: menuButtonSize)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState())
        menuButton.addTarget(self, action: #selector(showMenuBase), for: .touchUpInside)
        menuButton.tintColor = .white
        
        view.addSubview(menuButton)
        
        chatButton.frame = CGRect(x: rightItemX, y: topMargin, width: buttonSize, height: buttonSize)
        chatButton.addTarget(self, action: #selector(showSearchBarView), for: .touchUpInside)
        chatButton.setImage(UIImage(named: "speechIcon"), for: UIControlState())
        chatButton.tintColor = .white
        
        view.addSubview(menuButton)
        view.addSubview(chatButton)
        
        // The second view at the top of the page consists of the search bar (waiting for user input) and cancel button (to exit editing mode)
        // This view appears when users click the chat button in the first view.
        
        textControl.frame = CGRect(x: leftItemX, y: topMargin, width: textfieldWidth, height: textfieldHeight)
        textControl.delegate = self
        
        cancelButton.frame = CGRect(x: rightItemX, y: topMargin, width: buttonSize, height: buttonSize)
        cancelButton.addTarget(self, action: #selector(hideSearchBarView), for: .touchUpInside)
        cancelButton.setImage(UIImage(named: "cancel"), for: UIControlState())
        cancelButton.tintColor = .white
        
        view.addSubview(cancelButton)
        view.addSubview(textControl)
        
        
        // The sidebar consists of help button and ticket button.
        // Users can navigate to help page and ticket page by clicking the button.
        
        menuView.frame = CGRect(x: 0, y: 0 , width: menuWidth, height: Int(self.view.frame.size.height))
        menuView.backgroundColor = colors.menuBar
        
        helpButton.frame = CGRect(x: sideMargin/5, y: (Int(self.view.frame.height/2) - 50) , width: menuWidth, height: buttonSize)
        helpButton.addTarget(self, action: #selector(navHelp), for:    .touchUpInside)
        helpButton.tintColor = .white
        helpButton.setImage(UIImage(named: "helpIcon"), for: UIControlState())
        helpButton.setTitle("  Help", for: UIControlState())
        
        ticketButton.frame = CGRect(x: sideMargin/5, y: (Int(self.view.frame.height/2) + 50), width: menuWidth, height: buttonSize)
        ticketButton.tintColor = .white
        ticketButton.addTarget(self, action: #selector(navTicket), for: .touchUpInside)
        ticketButton.setImage(UIImage(named: "ticketIcon"), for: UIControlState())
        ticketButton.setTitle("  Ticket", for: UIControlState())
        
        view.addSubview(menuView)
        view.addSubview(helpButton)
        view.addSubview(ticketButton)
        
        // Microphone button
        
        micButton.center.x = self.view.center.x
        micButton.center.y = self.view.frame.maxY - 30
        micButton.addTarget(self, action: #selector(micPress), for: .touchUpInside)
        micButton.setImage(UIImage(named: "icons8-microphone-96"), for: UIControlState())
        
        view.addSubview(micButton)

        hideMenuBase()
        hideSearchBarView()
        
    }
    
    // When microphone button is pressed, the application proceeds the input given by users.
    func micPress() {
        // let startSound: SystemSoundID = 1110
        //let endSound : SystemSoundID = 1111
        
        if self.isRecording {
            // AudioServicesPlaySystemSound(endSound)
            CapitoController.getInstance().cancelTalking()
            print("if")
            
            helper.showAlert(message: "Done Listening")
        }
        else {
            //  AudioServicesPlaySystemSound(startSound)
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
        }
    }
    
    // Navigate users to Ticket page
    func navTicket() {
        hideMenuBase()
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TicketPage") as! TicketViewController
        present(detailViewController, animated: true, completion: nil)
    }
    
    // Navigate users to Help page
    func navHelp() {
        hideMenuBase()
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "HelpPage") as! HelpViewController
        let pageViewController = self.parent as! PageViewController
        detailViewController.pageIndex = pageViewController.pages.index(of: self)
        present(detailViewController, animated: true, completion: nil)
    }
    
    
    
    // Show menu side bar
    func showMenuBase() {
        menuTap = UITapGestureRecognizer(target: self, action: #selector(hideMenuBase))
        view.addGestureRecognizer(menuTap)
        micButton.isEnabled = false
        UIView.animate(withDuration: 1, animations: {
            self.menuView.isHidden = false
            self.ticketButton.isHidden = false
            self.helpButton.isHidden = false
        }, completion: nil)
    }
    
    // Hide menu side bar
    func hideMenuBase() {
        UIView.animate(withDuration: 1, animations: {
            self.ticketButton.isHidden = true
            self.helpButton.isHidden = true
            self.menuView.isHidden = true
        }, completion: nil)
        if menuTap != nil {
            view.removeGestureRecognizer(menuTap)
        }
        micButton.isEnabled = true
    }
    
    // Show search bar
    func showSearchBarView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelButton.isHidden = false
            self.textControl.isHidden = false
            self.menuButton.isHidden = true
            self.chatButton.isHidden = true
        }, completion: { finished in self.textControl.becomeFirstResponder()})
    }
    
    // Hide search bar
    func hideSearchBarView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelButton.isHidden = true
            self.textControl.isHidden = true
            
            self.menuButton.isHidden = false
            self.chatButton.isHidden = false
        }, completion: nil)
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

// Subclasses of AVTBaseViewController has differnt ways to handle the context, thus needs to override these functions
extension AVTBaseViewController {
    
    func handle(text:String){
        fatalError("Subclasess of AVTBaseViewController need to implement handle()");
    }
    
    func handle(response: CapitoResponse) {
        fatalError("Subclasess of AVTBaseViewController need to implement handle()");
    }
    
    func handleBuyTickets() {
        fatalError("Subclasess of AVTBaseViewController need to implement handleBuyTickets()");
    }
    
}

extension AVTBaseViewController{
    
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
    }
    
}

// Subclasses of AVTBaseViewController has differnt ways to handle the context, thus needs to override some of these functions
extension AVTBaseViewController: SpeechDelegate{
    
    func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        fatalError("Subclasess of AVTBaseViewController need to implement speechControllerProcessing()");
    }
    
    func speechControllerDidFinish(withResults response: CapitoResponse!) {
        fatalError("Subclasess of AVTBaseViewController need to implement speechControllerDidFinish()");
    }
    
    func speechControllerDidFinishWithError(_ error: Error!) {
        fatalError("Subclasess of AVTBaseViewController need to implement speechControllerDidFinishWithError()");
    }
    
    // Change the image of microphone to prompt for user speech
    func speechControllerDidBeginRecording() {
        self.isRecording = true
        self.micButton.setImage(pressedMic, for: .normal)
    }
    
    // Change the image back when users finish their speech
    func speechControllerDidFinishRecording() {
        self.isRecording = false
        self.micButton.setImage(readyMic, for: .normal)
    }
}

extension AVTBaseViewController: TextDelegate{
    
    func textControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    func textControllerDidFinishWithError(_ error: Error!){
        self.hideProcessingHUD()
        self.showError(error)
    }
}
