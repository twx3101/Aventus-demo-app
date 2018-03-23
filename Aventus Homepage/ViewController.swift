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
    @IBOutlet weak var utter1Label: UILabel!
    
    @IBOutlet weak var utter2Label: UILabel!
    
    @IBOutlet weak var waveFrame: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.bg
        self.waveFrame.backgroundColor = colors.bg
        genWave()
        
        // Do any additional setup after loading the view, typically from a nib.
        
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

}

