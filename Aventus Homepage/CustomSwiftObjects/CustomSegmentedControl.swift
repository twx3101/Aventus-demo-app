//
//  CustomSegmentedControl.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    //let selectedBackgroundColor = UIColor(red: 19/255, green: 59/255, blue: 85/255, alpha: 0.5)
    var sortedViews: [UIView]!
    var currentIndex: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        self.backgroundColor = colors.buttonBg
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        changeSelectedIndex(to: currentIndex)
        
        self.tintColor = UIColor.clear
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        

        
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews[currentIndex].backgroundColor = UIColor.purple
        
        let unselectedAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:  UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)]
        
        let selectedAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:  UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
        

        
    }
}
