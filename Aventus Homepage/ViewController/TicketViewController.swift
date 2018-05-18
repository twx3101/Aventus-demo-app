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
    
    var footerHeight: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper.setBackground(view: self.view, image: "ticketBg")
        tableView.backgroundColor = .clear
        //self.view.backgroundColor = colors.greyBg
        //tableView.backgroundColor = colors.greyBg
        
        headerWidth = Double(self.view.frame.width - 16)
        headerHeight = SCALE*headerWidth
        
        print(headerWidth)
        print(headerHeight)
        
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
        
        let bgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: headerHeight))
        bgView.backgroundColor = .clear
        //header.contentView.insertSubview(bgView, at: 0)
        //header.insertSubview(bgView, at: 0)
        
        //let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: headerHeight) )
        let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: Double(self.tableView.bounds.size.width), height: Double(headerHeight)) )
        bgImageView.image = UIImage(named: "mainTicket")
        bgImageView.contentMode = .scaleToFill
        //bgImageView.contentMode = .scaleAspectFill
        //bgImageView.contentMode = .scaleAspectFit
        bgImageView.center.x = self.view.frame.width/2
        //bgImageView.center.x = header.contentView.center.x
        
        header.contentView.insertSubview(bgImageView, at: 0)
        //header.insertSubview(bgImageView, at: 0)
        
        let artistLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: 100))
        
        artistLabel.text = userBookings[section].eventArtist
        artistLabel.textAlignment = .center
        artistLabel.textColor = colors.pink
        artistLabel.font = UIFont(name:"Sarabun", size: 36)
        
        
        let dateLabel = UILabel(frame: CGRect(x: 0.0, y: headerHeight/2.75, width: headerWidth, height: 100))
        
        dateLabel.text = userBookings[section].eventDatetime
        dateLabel.textAlignment = .center
        dateLabel.textColor = colors.purple
        dateLabel.font = UIFont(name:"Sarabun", size:22)
        
        let venueLabel = UILabel(frame: CGRect(x: 0.0, y: headerHeight/2, width: headerWidth, height: 100))
        
        venueLabel.text = userBookings[section].eventVenue! + " , " + userBookings[section].eventLocation!
        venueLabel.textAlignment = .center
        venueLabel.textColor = colors.purple
        venueLabel.font = UIFont(name:"Sarabun", size:22)
        
        
        header.addSubview(artistLabel)
        header.addSubview(dateLabel)
        header.addSubview(venueLabel)
        
        header.backgroundColor = .clear
        header.contentView.backgroundColor = .clear
        header.backgroundView = bgView
        
        return header
    }
    
    // How each ticket is displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.backgroundColor = .clear

        let detailLabel = UILabel(frame: CGRect(x: 35, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
        
        detailLabel.text = "Category: " + userBookings[indexPath.section].category!
        detailLabel.textColor = colors.pink
        detailLabel.font = UIFont(name:"Sarabun", size:20)
        
        let qrImageView =  UIImageView(frame: CGRect(x: self.view.frame.width - 80, y: 5, width: 35, height: 35))
        qrImageView.image = UIImage(named: "qrcode")
        
        let ticketImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: cellHeight))
        ticketImageView.image = UIImage(named: "ticket")
        ticketImageView.contentMode = .scaleToFill
        //ticketImageView.contentMode = .scaleAspectFit
        //ticketImageView.contentMode = .scaleAspectFill
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
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //let bgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: footerHeight))
        //bgView.backgroundColor = .clear
        let footer = UIView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: footerHeight))
        footer.backgroundColor = .clear
        return footer
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
        return CGFloat(footerHeight)
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

