//
//  ViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 01/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var userSpeech: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: Actions
    @IBAction func recordButton(_ sender: UIButton) {
        userSpeech.text = "Done Listening"
    }

}

