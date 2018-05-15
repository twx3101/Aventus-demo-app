//
//  HelpViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var utterView: UIStackView!
    
    @IBOutlet weak var headerView: UIView!
    
    let height = 40
    
    let width = 343
    
    // The index of page users currently are before Help page is presented
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper.setBackground(view: self.view, image: "helpBg")
       
        let index: Int = pageIndex!
        
        var labels = [UILabel]()
        
        // The label displayed at the top
        let topLabel = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: 80))
        topLabel.textColor = .white
        topLabel.lineBreakMode = .byWordWrapping
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        
        // The label displayed at the middle of the page, depending on where users come from
        switch(index) {
        
        case pageNo.home:
            
            topLabel.text = "Here are some examples of what you can say to me"
            
            let label1 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label1.text = "\"Buy me two standing tickets to Rihanna on 19th May\""
            label1.lineBreakMode = .byWordWrapping
            label1.numberOfLines = 0
            labels.append(label1)

            let label2 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label2.text = "\"Find me rock events\""
            
            labels.append(label2)
            
            let label3 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label3.text = "\"Search for events in Birmingham\""
            labels.append(label3)
            
            let label4 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label4.text = "\"Find me tickets less than 20 pounds\""
            
            labels.append(label4)
            
            
        case pageNo.event:
             topLabel.text = "Here you can filter your search results"
            
            let label1 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label1.text = "\"Don't show me Justin Bieber events\""
            
            labels.append(label1)
            
            let label2 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label2.text = "\"Find me events in the next 2 weeks\""
            
            labels.append(label2)
            
            let label3 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label3.text = "\"I want to go to Liverpool\""
             
            labels.append(label3)
            
            let label4 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label4.text = "\"I want to go to pop music events\""
             
            labels.append(label4)
            
            let label5 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label5.text = "\"I want to see events less than 20 quid\""
             
            labels.append(label4)
        
        case pageNo.seat:
            topLabel.text = "Here I can help you purchase tickets for your event"
            
            let label1 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label1.text = "\"Buy me 2 standing tickets\""
            
            labels.append(label1)
            
            let label2 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label2.text = "\"Book 4 Category A seats\""
            
            labels.append(label2)
            
            let label3 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label3.text = "\"I want 1 Category B ticket\""
            
            labels.append(label3)
        default:
            print(index)
        }
        
        headerView.addSubview(topLabel)
        
        for var label in labels {
            label.center = self.view.center
            label.textAlignment = NSTextAlignment.center
            utterView.addArrangedSubview(label)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPreviousPage(_:))))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Go back to the previous page
    @objc func goPreviousPage(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    
}
