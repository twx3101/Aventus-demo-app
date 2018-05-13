//
//  HelpViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var headerLabel: UtterLabel!

    @IBOutlet weak var utterView: UIStackView!
    
    let height = 40
    
    let width = 343
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.view.backgroundColor = colors.bg
        helper.setBackground(view: self.view, image: "helpBg")
        
        headerLabel.textColor = colors.headerTwoText
        
        let index: Int = pageIndex!
        
        var labels = [UILabel]()
        
        switch(index) {
        case pageNo.home:

            let label1 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label1.text = "\"Hello from home\""
            
            labels.append(label1)

            let label2 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label2.text = "\"Hello from homehome\""
            
            labels.append(label2)
            
            let label3 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label3.text = "\"Hello from homehomehome\""
            
            labels.append(label3)
            
        case pageNo.event:
            
            let label1 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label1.text = "\"Hello from event\""
            
            labels.append(label1)
            
            let label2 = UtterLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label2.text = "\"Hello from homehome\""
            
            labels.append(label2)
            
        default:
            print(index)
        }
        
        //utterView.frame.
        utterView.distribution = .fill
        utterView.alignment = .fill;
        utterView.spacing = 32;
        
        for var label in labels {
            label.center = self.view.center
            label.textAlignment = NSTextAlignment.center
            utterView.addArrangedSubview(label)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPreviousPage(_:))))

        // Do any additional setup after loading the view.
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
    @objc func goPreviousPage(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    
}
