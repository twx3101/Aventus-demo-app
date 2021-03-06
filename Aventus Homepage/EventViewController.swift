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
    
    let cellIdentifier = "EventTableViewCell"
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    //let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
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
        cell.locationDatetimeLabel.text = event.location + " " + event.datetime
        cell.descriptionLabel.text = event.description
        cell.artistPhoto.image = event.photo
        
        cell.backgroundColor = colors.tableBg
        
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
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = colors.bg
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"

        /*let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.activityIndicatorView = activityIndicatorView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)*/
        //activityIndicatorView.startAnimating()
        loadEvents()
        //activityIndicatorView.stopAnimating()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if events.count == 0 {
            activityIndicatorView.startAnimating()
            
            dispatchQueue.async {
                Thread.sleep(forTimeInterval: 3)
                
                OperationQueue.main.addOperation() {
                    self.loadEvents()
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                }
            }
        }
    }*/

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
    func parseJSON(){
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
    }
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
        
        
	
        /*let photo1 = UIImage(named: "drake")
        let photo2 = UIImage(named: "selena")
        //let photo1 = UIImage(named: "drake")
        //let photo2 = UIImage(named: "selena")
        
        // need to deal with when there is no seat availiable for some catogories or for all categories
        // is it possible to have categories.size() != no_seats_avail.size() != no_categories
       let seating1 = Seating(categories: ["CatA", "CatB", "CatC", "CatD"], price: [50, 150, 200, 250], noSeatsAvail: [10,10,10,10], noCategories: 4)
        let seating2 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE"], price: [50, 150, 200, 250, 300], noSeatsAvail: [10,10,0,10,10], noCategories: 5)
        let seating3 = Seating(categories: ["CatA", "CatB", "CatC", "CatD", "CatE", "CatG"], price: [50, 150, 200, 250,300, 360], noSeatsAvail: [10,10,10,10, 10, 10], noCategories: 6)
        
        guard let event1 = Event(artist: "Drake", location: "London", datetime: "today", description: nil, photo: photo1, seating: seating1) else{
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(artist: "Selena", location: "London", datetime: "tomorrow", description: nil, photo: photo2, seating: seating2) else{
            fatalError("Unable to instantiate event2")
        }
        
        guard let event3 = Event(artist: "Selena", location: "London", datetime: "next week", description: nil, photo: photo2, seating: seating3) else{
            fatalError("Unable to instantiate event3")
        } */
        parseJSON()
        
        
        
        //events += [event1, event2, event3]
        
    }
    
}
    extension EventViewController: UISearchResultsUpdating{
        
        func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchController.searchBar.text!)
            
        }
        
    }

    

