//
//  ConfirmTableViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 17/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
