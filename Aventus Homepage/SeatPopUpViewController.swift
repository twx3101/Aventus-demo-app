//
//  SeatPopUpViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 17/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SeatPopUpViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPreviousPage(_:))))
        
        self.showAnimate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @objc func goPreviousPage(_ tap: UITapGestureRecognizer) {
        removeAnimate()
        
    }
}
