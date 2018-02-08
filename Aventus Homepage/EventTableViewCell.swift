//
//  EventTableViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 08/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // Mark: Properties
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var locationDatetimeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var artistPhoto: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
