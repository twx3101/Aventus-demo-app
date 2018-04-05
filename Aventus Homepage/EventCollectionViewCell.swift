//
//  EventCollectionViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var locationDatetimeLabel: UILabel!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //containerView.layer.cornerRadius = 15.0
        //containerView.clipsToBounds = true
        //containerView.layer.masksToBounds = true
        //containerView.backgroundColor = colors.bg
        
        //artistPhoto.layer.cornerRadius = 15.0
        //artistPhoto.clipsToBounds = true
        
        //descriptionView.backgroundColor = colors.bg
        //descriptionView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
}
