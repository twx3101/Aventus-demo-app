//
//  SummaryTableViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 06/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    // Mark: Properties

    @IBOutlet weak var detailRightLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
