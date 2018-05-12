//
//  BaseViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 11/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class AVTBaseViewController: UIViewController, UITextFieldDelegate {
    
    var menuView: UIView = UIView()
    
    var helpButton: UIButton = UIButton(type: UIButtonType.system)
    var ticketButton: UIButton = UIButton(type: UIButtonType.system)
    
    var menuButton: UIButton = UIButton(type: UIButtonType.system)
    var searchButton: UIButton = UIButton(type: UIButtonType.system)

    var textControl: UITextField = SearchTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    var cancelButton: UIButton = UIButton(type: UIButtonType.system)
    
    var SCALE: Float!
    
    var sideMargin: Int  = 20
    var topMargin: Int = 35
    var buttonSize: Int = 30
    var textfieldHeight: Int = 30
    var textfieldWidth: Int = 0
    var menuWidth: Int = 200
    
    var leftItemX: Int = 0
    var rightItemX: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftItemX = sideMargin
        rightItemX = Int(self.view.frame.width) - sideMargin - buttonSize
        
        textfieldWidth = Int(self.view.frame.width) - (sideMargin*2) - buttonSize
        
        menuButton.frame = CGRect(x: leftItemX, y: topMargin, width: buttonSize, height: buttonSize)
        //menuButton.addTarget(self, action: #selector(openMenu), for:    .touchUpInside)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState())
        menuButton.tintColor = .white
        
        view.addSubview(menuButton)
        
        searchButton.frame = CGRect(x: rightItemX, y: topMargin, width: buttonSize, height: buttonSize)
        searchButton.addTarget(self, action: #selector(showSearchBarView), for:    .touchUpInside)
        searchButton.setImage(UIImage(named: "search"), for: UIControlState())
        searchButton.tintColor = .white
        
        view.addSubview(menuButton)
        view.addSubview(searchButton)
        
        
        
        textControl.frame = CGRect(x: leftItemX, y: topMargin, width: textfieldWidth, height: textfieldHeight)
        
        textControl.delegate = self
        
        cancelButton.frame = CGRect(x: rightItemX, y: topMargin, width: buttonSize, height: buttonSize)
        cancelButton.addTarget(self, action: #selector(hideSearchBarView), for:    .touchUpInside)
        cancelButton.setImage(UIImage(named: "cancel"), for: UIControlState())
        cancelButton.tintColor = .white
        
        view.addSubview(cancelButton)
        view.addSubview(textControl)
        
        menuView.frame = CGRect(x: 0, y: 0 , width: menuWidth, height: Int(self.view.frame.size.height))
        menuView.backgroundColor = colors.greyBg
        
        
        helpButton.frame = CGRect(x: sideMargin/2, y: (Int(self.view.frame.height/2) - 20) , width: buttonSize, height: buttonSize)
        helpButton.addTarget(self, action: #selector(navHelp), for:    .touchUpInside)
        helpButton.setImage(UIImage(named: "search"), for: UIControlState())
        helpButton.setTitle("Help", for: UIControlState())
        
        
        ticketButton.frame = CGRect(x: sideMargin/2, y: (Int(self.view.frame.height/2) + 20), width: buttonSize, height: buttonSize)
        ticketButton.addTarget(self, action: #selector(navTicket), for:    .touchUpInside)
        ticketButton.setImage(UIImage(named: "search"), for: UIControlState())

        
        view.addSubview(menuView)
        view.addSubview(helpButton)
        view.addSubview(ticketButton)
        
        hideMenuBase()
        hideSearchBarView()
        
        
    }
    
    func navTicket() {
        
        hideMenuBase()

        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TicketPage") as! TicketViewController
        
        present(detailViewController, animated: true, completion: nil)
    
    }
    
    func navHelp() {
        hideMenuBase()
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "HelpPage") as! HelpViewController
        
        let pageViewController = self.parent as! PageViewController
        
        detailViewController.pageIndex = pageViewController.pages.index(of: self)
        
        present(detailViewController, animated: true, completion: nil)
    }
    
    func showMenuBase() {
        
        menuView.isHidden = false
        ticketButton.isHidden = false
        helpButton.isHidden = false
    }
    
    func hideMenuBase() {
        ticketButton.isHidden = true
        helpButton.isHidden = true
        menuView.isHidden = true
        
    }
    
    func showSearchBarView() {

        
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelButton.isHidden = false
            self.textControl.isHidden = false

            self.menuButton.isHidden = true
            self.searchButton.isHidden = true
        }, completion: { finished in self.textControl.becomeFirstResponder()})
    }
    
    
    func openMenu() {
    }
    
    func hideSearchBarView() {

        
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelButton.isHidden = true
            self.textControl.isHidden = true
            
            self.menuButton.isHidden = false
            self.searchButton.isHidden = false
        }, completion: nil)
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

}
