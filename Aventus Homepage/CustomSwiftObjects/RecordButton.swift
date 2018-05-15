//
//  RoundButton.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 25/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

// microphone button
class RecordButton: UIButton{
    override init(frame: CGRect){
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder(){
        sharedInit()
    }
    
    func sharedInit(){
        layer.cornerRadius = frame.height/2
    }
    

}
