//
//  TicketViewController.swift
//  Ticket
//
//  Created by Krongsiriwat, Krantharat on 12/05/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let SCALE: Double = 143.0/401
    
    var headerWidth: Double = 0
    var headerHeight: Double = 0
    
    var cellWidth: Double = 0
    var cellHeight: Double = 0
    
    var sections = [
        Section(genre: "A", movies: ["dd","dd","dd"], expanded: false),
        Section(genre: "B", movies: ["ds", "s"], expanded: false),
        Section(genre: "C", movies: ["A"], expanded: false)
        
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
        detailLabel.text = sections[indexPath.section].movies[indexPath.row]
        detailLabel.textAlignment = .center
        detailLabel.textColor = UIColor.black
        
        let qrImageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        qrImageView.image = UIImage(named: "qrcode")
        qrImageView.center.x = self.view.frame.width/2
        
        cell.insertSubview(qrImageView, at: 50)
        
        cell.addSubview(detailLabel)
        
        if indexPath.section == (sections.count - 1) {
            if sections[indexPath.section].expanded  {
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(sections[indexPath.section].expanded) {
            return CGFloat(cellHeight)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        
        header.customInit(title: sections[section].genre, section: section, delegate: self)
        
        let bgImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: headerHeight) )
        bgImageView.image = UIImage(named: "mainTicket")
        bgImageView.center.x = self.view.frame.width/2
        
        header.contentView.insertSubview(bgImageView, at: 0)
        
        let artistLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: headerWidth, height: 100))
        
        artistLabel.text = sections[section].genre
        artistLabel.textAlignment = .center
        artistLabel.textColor = UIColor.black
        
        header.addSubview(artistLabel)
        
        return header
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        
        
        
        for i in 0..<sections[section].movies.count {

            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = colors.greyBg
        
        headerWidth = Double(self.view.frame.width - self.view.layoutMargins.left - self.view.layoutMargins.right)
        headerHeight = SCALE*headerWidth
        
        cellWidth = headerWidth
        cellHeight = 44
        
        tableView.allowsSelection = false
        
        //let tickets: [String] = ["ll"]
        
        //UserDefaults.standard.set(tickets, forKey: "Key")
        
        if let readtickets = UserDefaults.standard.object(forKey: "Test") {
            let arrayTickets = readtickets as! [String]
            //print(string!)
            
            for ticket in arrayTickets {
                print(ticket)
            }
        } else {
            print("no data")
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goPreviousPage(_:))))
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func goPreviousPage(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
}

