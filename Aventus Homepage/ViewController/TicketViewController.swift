//
//  TicketViewController.swift
//  Ticket
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate  {

    var userBookings: [Booking] = []
    
    @IBOutlet weak var tableView: UITableView!

    
    let SCALE: Double = 143.0/401
    
    var headerWidth: Double = 0
    var headerHeight: Double = 0
    
    var cellWidth: Double = 0
    var cellHeight: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.greyBg
        tableView.backgroundColor = colors.greyBg
        
        headerWidth = Double(self.view.frame.width - self.view.layoutMargins.left - self.view.layoutMargins.right)
        headerHeight = SCALE*headerWidth
        
        cellWidth = headerWidth
        cellHeight = 44
        
        tableView.allowsSelection = false
        
        // retrieve the data saved in users' phone
        userBookings = helper.retrieveDataFromKey(key: "Bookings")
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPreviousPage(_:))))
        
    }
    
    // The number of bookings
    func numberOfSections(in tableView: UITableView) -> Int {
        return userBookings.count
    }
    
    // The number of tickets for each booking
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(userBookings[section].noTickets!)!
    }
    
    // How each booking is displayed
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        
        header.customInit(title: userBookings[section].eventArtist!, section: section, delegate: self)
        
        let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: headerHeight) )
        bgImageView.image = UIImage(named: "mainTicket")
        bgImageView.center.x = self.view.frame.width/2
        
        header.contentView.insertSubview(bgImageView, at: 0)
        
        let artistLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: 100))
        
        artistLabel.text = userBookings[section].eventArtist
        artistLabel.textAlignment = .center
        artistLabel.textColor = UIColor.black
        
        let dateLabel = UILabel(frame: CGRect(x: 0.0, y: headerHeight*2/5, width: headerWidth, height: 100))
        
        dateLabel.text = userBookings[section].eventDatetime
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black
        
        let venueLabel = UILabel(frame: CGRect(x: 0.0, y: headerHeight/2, width: headerWidth, height: 100))
        
        venueLabel.text = userBookings[section].eventVenue! + " , " + userBookings[section].eventLocation!
        venueLabel.textAlignment = .center
        venueLabel.textColor = UIColor.black
        
        
        header.addSubview(artistLabel)
        header.addSubview(dateLabel)
        header.addSubview(venueLabel)
        
        return header
    }
    
    // How each ticket is displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.backgroundColor = .clear

        let detailLabel = UILabel(frame: CGRect(x: 20, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
        
        detailLabel.text = "Category: " + userBookings[indexPath.section].category!
        detailLabel.textColor = UIColor.black
        
        let qrImageView =  UIImageView(frame: CGRect(x: self.view.frame.width - 80, y: 0, width: 40, height: 40))
        qrImageView.image = UIImage(named: "qrcode")
        
        let ticketImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.contentView.frame.height))
        ticketImageView.image = UIImage(named: "ticket")
        ticketImageView.center.x = self.view.frame.width/2
        
        cell.insertSubview(qrImageView, at: Int(self.view.frame.width))
        cell.insertSubview(ticketImageView, at: 0)
        
        cell.addSubview(detailLabel)
        
        // Hide all rows in the last section if the section has not been clicked
        // Needed when users just navigate to the page
        if indexPath.section == (userBookings.count - 1) {
            if (userBookings[indexPath.section].expanded == "0") {
                cell.isHidden = true
            } else {
                cell.isHidden = false

            }
        }
        
        return cell
    }
    
    // The height for the booking
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)
    }
    
    // The height for the ticket
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // if it is expanded (clicked), display the row
        if(userBookings[indexPath.section].expanded == "1") {
            return CGFloat(cellHeight)
        } else {
            return 0
        }
    }
    
    // The gap between any two sections
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    // When users click on the booking, display every ticket corresponded with the booking
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        if (userBookings[section].expanded == "0") {
            userBookings[section].expanded = "1"
            
        } else {
            userBookings[section].expanded = "0"
        }
        
        tableView.beginUpdates()
        let noTick = Int(userBookings[section].noTickets!)!
        for i in 0..<noTick {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Go back to previous page
    @objc func goPreviousPage(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
}

