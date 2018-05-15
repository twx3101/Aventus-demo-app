//
//  EventCollectionViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit


// The contents in the collection view cell displayed in EventViewController
class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var locationDatetimeLabel: UILabel!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var priceLabel: DescriptionLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
