//
//  EventViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 08/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var events = [Event]()
    var filteredEvents = [Event]()
    let searchController = UISearchController(searchResultsController: nil)
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredEvents.count
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else{
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        let event : Event
        if isFiltering(){
              event = filteredEvents[indexPath.row]
        }
        else {
             event = events[indexPath.row]
        }
        cell.artistLabel.text = event.artist
        cell.locationDatetimeLabel.text = event.location + " " + event.datetime + " " + event.time
        cell.descriptionLabel.text = event.description
        cell.artistPhoto.image = event.photo
        
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeatSegue" {
            let detailViewController = segue.destination as! SeatViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            if isFiltering(){
                detailViewController.eventLoaded = filteredEvents[row]
            }
            else{
                detailViewController.eventLoaded = events[row]
            }
            
            
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

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        //print("HELLO")
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
    /*func parseJSON(){
        let url = String(format: "https://sheetsu.com/apis/v1.0bu/c2358558ce5f")
        let serviceURL = URL(string: url)
        var request = URLRequest(url: serviceURL!)
        
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data{
                do{
                    let json =  try JSONSerialization.jsonObject(with: data, options: [])
                    if let event_list = json as? NSArray{
                        for i in 0 ..< event_list.count {
                            let eve = event_list[i] as? [String:Any]
                            let event1 = Event(json:eve!)
                                self.events.append(event1!)
                        }
                    }
                }
                    
                catch{
                    print(error)
                    return
                }
                
            //convert JSON data into Event Class
           
        print("HELLO")
            
            DispatchQueue.main.async{ [unowned self] in
                self.tableView.reloadData()
            }
    
            }
        }.resume()
    }*/
    
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty()-> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        filteredEvents = events.filter({( event:Event) -> Bool in
            return event.artist.lowercased().contains(searchText.lowercased()) || event.location.lowercased().contains(searchText.lowercased())
            
        })
        tableView.reloadData()
    }
    
    private func loadEvents(){
        
        

        //let photo1 = UIImage(named: "drake")
        //let photo2 = UIImage(named: "selena")
        
        // need to deal with when there is no seat availiable for some catogories or for all categories
        // is it possible to have categories.size() != no_seats_avail.size() != no_categories
        var seating1 = Seating(categories: ["CatA", "CatB", "CatC", "CatD"], price: [50, 150, 200, 250], noSeatsAvail: [10,10,10,10], noCategories: 4)
        /*let seating2 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE"], price: [50, 150, 200, 250, 300], noSeatsAvail: [10,10,0,10,10], noCategories: 5)
        let seating3 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE", "CatG"], price: [50, 150, 200, 250,300, 360], noSeatsAvail: [10,10,10,10, 10, 10], noCategories: 6)*/
        /*
        guard let event1 = Event(artist: "Drake", location: "London", datetime: "today", description: nil, photo: photo1, seating: seating1) else{
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(artist: "Selena", location: "London", datetime: "tomorrow", description: nil, photo: photo2, seating: seating2) else{
            fatalError("Unable to instantiate event2")
        }
        
        guard let event3 = Event(artist: "Selena", location: "London", datetime: "next week", description: nil, photo: photo2, seating: seating3) else{
            fatalError("Unable to instantiate event3")
        } */
        //parseJSON()
        
        //events += [event1, event2, event3]
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Retrieve the posts and listen for changes
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            //    let postDict = snapshot.value as? [0] ?? [:]
           // print(snapshot.value)
            
          //Getting information for events
            for event in snapshot.children.allObjects as![DataSnapshot]{
                let eventObject = event.value as? [String: AnyObject]
                let eventArtist = eventObject?["Artist"]
                let eventDate = eventObject?["Local Date"]
                let eventLocation = eventObject?["Fake City"]
                let eventTime = eventObject?["Local Time"]
                
                let eventCat1Area = eventObject?["Area: category 1"]
                let eventCat2Area = eventObject?["Area: category 2"]
                let eventCat3Area = eventObject?["Area: category 3"]
                let eventCat4Area = eventObject?["Area: category 4"]
                let eventCat5Area = eventObject?["Area: category 5 Standing"]
                
                print(event)
                
                let eventCatArea = [eventCat1Area, eventCat2Area, eventCat3Area, eventCat4Area, eventCat5Area]
                
                /*let eventCat1Price = Int((eventObject?["Category 1: Price"])! as! NSNumber)
                let eventCat2Price = Int((eventObject?["Category 2: Price"])! as! NSNumber)
                let eventCat3Price = Int((eventObject?["Category 3: Price"])! as! NSNumber)
                let eventCat4Price = Int((eventObject?["Category 4: Price"])! as! NSNumber)
                let eventCat5Price = Int((eventObject?["Category 5(standing area): Price"])! as! NSNumber)*/
                
                let eventCat1Price = eventObject?["Category 1: Price"]
                let eventCat2Price = eventObject?["Category 2: Price"]
                let eventCat3Price = eventObject?["Category 3: Price"]
                let eventCat4Price = eventObject?["Category 4: Price"]
                let eventCat5Price = eventObject?["Category 5(standing area): Price"]
                
                print(eventCat1Price)
                print(eventCat2Price)
                let eventCatPrice = [eventCat1Price , eventCat2Price , eventCat3Price , eventCat4Price , eventCat5Price ]
                
                /*let eventCat1Seats = Int((eventObject?["Number of seat available"])! as! NSNumber)
                let eventCat2Seats = Int((eventObject?["Number of seat available"])! as! NSNumber)
                let eventCat3Seats = Int((eventObject?["Number of seat available"])! as! NSNumber)
                let eventCat4Seats = Int((eventObject?["Number of seat available"])! as! NSNumber)
                let eventCat5Seats = Int((eventObject?["Number of seat available"])! as!  NSNumber)*/
            
                
                let eventCat1Seats = eventObject?["Number of seat available"]
                let eventCat2Seats = eventObject?["Number of seat available"]
                let eventCat3Seats = eventObject?["Number of seat available"]
                let eventCat4Seats = eventObject?["Number of seat available"]
                let eventCat5Seats = eventObject?["Number of seat available"]
                
                let eventCatSeats = [eventCat1Seats, eventCat2Seats, eventCat3Seats, eventCat4Seats, eventCat5Seats]
                
                //let eventCatSeats = [eventCat1Seats as! Int, eventCat2Seats as! Int, eventCat3Seats as! Int, eventCat4Seats as! Int, eventCat5Seats as! Int]
                
                //seating1 = Seating(categories: eventCatArea as! [String], price: eventCatPrice, noSeatsAvail: eventCatSeats, noCategories: 5)
                
                let event1 = Event(artist: eventArtist as! String, location: eventLocation as! String, datetime: eventDate as! String, description: nil, photo: nil, seating: seating1, time: eventTime as! String)
        
                self.events.append(event1!)
            }
    
            
            self.tableView.reloadData()
            //Code to execute to obtain the information held in the value field in the database
        })
    }
    
}
    extension EventViewController: UISearchResultsUpdating{
        
        func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchController.searchBar.text!)
            
        }
        
    }

    

