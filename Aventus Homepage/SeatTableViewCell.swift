//
//  SeatTableViewCell.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 17/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class SeatTableViewCell: UITableViewCell {
    

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var noSeatsLabel: UILabel!
    
    @IBOutlet weak var selectedSeats: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func upButton(_ sender: UIButton) {
        let selected:Int? = Int(selectedSeats.text!)
        let avail:Int? = Int(noSeatsLabel.text!)
        if selected! < avail! {
            selectedSeats.text = String(selected!+1)
        }
    }
    
    @IBAction func downButton(_ sender: UIButton) {
        let selected:Int? = Int(selectedSeats.text!)
        //let avail:Int? = Int(noSeatsLabel.text!)
        if selected! != 0 {
            selectedSeats.text = String(selected!-1)
        }
    }
    

}
