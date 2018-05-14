//
//  SummaryTableViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 06/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    

    @IBOutlet weak var detailRightLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
