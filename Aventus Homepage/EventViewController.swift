//
//  EventViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 08/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else{
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        let event = events[indexPath.row]
        
        cell.artistLabel.text = event.artist
        cell.locationDatetimeLabel.text = event.location + " " + event.datetime
        cell.descriptionLabel.text = event.description
        cell.artistPhoto.image = event.photo
        
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeatSegue" {
            let detailViewController = segue.destination as! SeatViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
    
            detailViewController.eventLoaded = events[row]
            
            
            
            /*if(detailViewController.seating != nil) {
                detailViewController.seating.image = UIImage(named: "Seating")
            }*/
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.delegate = self
        //tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        // Load events to display
        loadEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadEvents(){
        let photo1 = UIImage(named: "drake")
        let photo2 = UIImage(named: "selena")
        
        // need to deal with when there is no seat availiable for some catogories or for all categories
        // is it possible to have categories.size() != no_seats_avail.size() != no_categories
        let seating1 = Seating(categories: ["CatA", "CatB", "CatC", "CatD"], no_seats_avail: [10,10,10,10], no_categories: 4)
        let seating2 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE"], no_seats_avail: [10,10,0,10,10], no_categories: 5)
        let seating3 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE", "CatG"], no_seats_avail: [10,10,10,10], no_categories: 6)
        
        guard let event1 = Event(artist: "Drake", location: "London", datetime: "today", description: nil, photo: photo1, seating: seating1) else{
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(artist: "Selena", location: "London", datetime: "tomorrow", description: nil, photo: photo2, seating: seating2) else{
            fatalError("Unable to instantiate event2")
        }
        
        guard let event3 = Event(artist: "Selena", location: "London", datetime: "next week", description: nil, photo: photo2, seating: seating3) else{
            fatalError("Unable to instantiate event3")
        }
        
        events += [event1, event2, event3]
        
    }


}
