//
//  EventViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 08/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import AlamofireImage

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "EventTableViewCell"
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var events = [Event]()
    var filteredEvents = [Event]()
    var isFiltering : Bool = false
    var filteredItems = Dictionary<String,Any>()
    let searchController = UISearchController(searchResultsController: nil)
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
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
        if isFiltering{
            event = filteredEvents[indexPath.row]
        }
        else {
            event = events[indexPath.row]
        }
        cell.artistLabel.text = event.artist
        cell.locationDatetimeLabel.text = event.location
        cell.descriptionLabel.text = event.datetime + " " + event.time
        Alamofire.request(event.imageURL).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value{
                cell.artistPhoto.image = image
            }
        }
        cell.backgroundColor = colors.tableBg
        return cell
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeatSegue" {
            let detailViewController = segue.destination as! SeatViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            if isFiltering{
                detailViewController.eventLoaded = filteredEvents[row]
            }
            else{
                detailViewController.eventLoaded = events[row]
            }
            
            
            /*if(detailViewController.seating != nil) {
             detailViewController.seating.image = UIImage(named: "Seating")
             }*/
            
        }
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("section: \(indexPath.section)")
        print(indexPath.row)
        let pageViewController = self.parent as! PageViewController
        
        //let detailViewController = pageViewController.pages[3] as! SeatViewController
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        if isFiltering {
            detailViewController.eventLoaded = filteredEvents[indexPath.row]
        } else {
            detailViewController.eventLoaded = events[indexPath.row]
        }
        
        pageViewController.pages[3] = detailViewController
        
        pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        view.backgroundColor = colors.bg
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
    
    func isFilteringBar() -> Bool{
        if(searchController.isActive && !searchBarIsEmpty()){
            isFiltering = true
        }
        else{
            isFiltering = false
        }
        return isFiltering
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
        
        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Retrieve the posts and listen for changes
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            //    let postDict = snapshot.value as? [0] ?? [:]
            // print(snapshot.value)
            
            //Getting information for events
            for event in snapshot.children.allObjects as![DataSnapshot]{
                let eventObject = event.value as? [String: AnyObject]
                let eventArtist = eventObject?["Fake Mainstream Events"]
                let eventDate = eventObject?["Local Date"]
                let eventLocation = eventObject?["Fake City"]
                let eventTime = eventObject?["Local Time (formatted)"]
                
                
                let eventArtistRanking = eventObject?["Artist Ranking"]
                let eventDayinWeek = eventObject?["Day in week"]
                let eventID = eventObject?["Event ID"]
                let eventImageURL = eventObject?["Fake Artist Pc JPEG URL"]
                let eventStatus = eventObject?["Event Status"]
                let eventVenue = eventObject?["Fake Venue"]
                let eventGenre = eventObject?["Genre"]
                let eventMonth = eventObject?["Month"]
                let eventTimezone = eventObject?["Timezone"]
                let eventAddress = eventObject?["Venue address"]
                let eventCity = eventObject?["Venue city"]
                let eventWeekend = eventObject?["Weekend"]
                
                var eventCatArea = [String]()
                
                eventCatArea.append(eventObject?["Area: category 1"] as! String)
                eventCatArea.append(eventObject?["Area: category 2"] as! String)
                eventCatArea.append(eventObject?["Area: category 3"] as! String)
                eventCatArea.append(eventObject?["Area: category 4"] as! String)
                eventCatArea.append(eventObject?["Area: category 5 Standing"] as! String)
                
                /*let eventCatArea[0] = eventObject?["Area: category 1"]
                 let eventCatArea[1] = eventObject?["Area: category 2"]
                 let eventCatArea[2] = eventObject?["Area: category 3"]
                 let eventCatArea[3] = eventObject?["Area: category 4"]
                 let eventCatArea[4] = eventObject?["Area: category 5 Standing"]*/
                
                //let eventCatArea: [String] = [eventCat1Area as! String, eventCat2Area as! String, eventCat3Area as! String, eventCat4Area as! String, eventCat5Area as! String]
                
                //print(eventCatArea)
                
                var eventCatPrice = [Int]()
                
                if let cat1 = eventObject?["Category 1: Price"] as? Int{ eventCatPrice.append(cat1)
                }
                else{
                    eventCatPrice.append(0)
                }
                if let cat2 = eventObject?["Category : Price"] as? Int{ eventCatPrice.append(cat2)
                }
                else{
                    eventCatPrice.append(0)
                }
                if let cat3 = eventObject?["Category 3: Price"] as? Int{ eventCatPrice.append(cat3)
                }
                else{
                    eventCatPrice.append(0)
                }
                if let cat4 = eventObject?["Category 4: Price"] as? Int{ eventCatPrice.append(cat4)
                }
                else{
                    eventCatPrice.append(0)
                }
                if let cat5 = eventObject?["Category 5(standing area): Price"] as? Int{ eventCatPrice.append(cat5)
                }
                else{
                    eventCatPrice.append(0)
                }
                
                /*let eventCat1Price = eventObject?["Category 1: Price"]
                 let eventCat2Price = eventObject?["Category 2: Price"]
                 let eventCat3Price = eventObject?["Category 3: Price"]
                 let eventCat4Price = eventObject?["Category 4: Price"]
                 let eventCat5Price = eventObject?["Category 5(standing area): Price"]
                 
                 let eventCatPrice: [Int] = [eventCat1Price as! Int , eventCat2Price as! Int , eventCat3Price as! Int , eventCat4Price as! Int , eventCat5Price as! Int ]*/
                
                //print(eventCatPrice)
                
                var eventCatSeats = [Int]()
                
                if let seat1 = eventObject?["Category 1: Number of seat available"] as? Int{ eventCatSeats.append(seat1)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                if let seat2 = eventObject?["Category 2: Number of seat available"] as? Int{ eventCatSeats.append(seat2)
                }
                else{
                    eventCatSeats.append(0)
                }
                if let seat3 = eventObject?["Category 3: Number of seat available"] as? Int{ eventCatSeats.append(seat3)
                }
                else{
                    eventCatSeats.append(0)
                }
                if let seat4 = eventObject?["Category 4: Number of seat available"] as? Int{ eventCatSeats.append(seat4)
                }
                else{
                    eventCatSeats.append(0)
                }
                if let seat5 = eventObject?["Category 5: Number of seat available"] as? Int{ eventCatSeats.append(seat5)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                /*let eventCat1Seats = eventObject?["Category 1: Number of seat available"]
                 let eventCat2Seats = eventObject?["Category 2: Number of seat available"]
                 let eventCat3Seats = eventObject?["Category 3: Number of seat available"]
                 let eventCat4Seats = eventObject?["Category 4: Number of seat available"]
                 let eventCat5Seats = eventObject?["Category 5: Number of seat available"]
                 
                 let eventCatSeats: [Int] = [eventCat1Seats as! Int, eventCat2Seats as! Int, eventCat3Seats as! Int, eventCat4Seats as! Int, eventCat5Seats as! Int]*/
                
                //print(eventCatSeats)
                
                var eventAvailCat = [String]()
                var eventAvailPrice = [Int]()
                var eventAvailSeats = [Int]()
                var no_avail_cat: Int = 0
                
                for i in 0...4 {
                    if eventCatPrice[i] != 0 {
                        eventAvailCat.append(eventCatArea[i])
                        eventAvailPrice.append(eventCatPrice[i])
                        eventAvailSeats.append(eventCatSeats[i])
                        no_avail_cat = no_avail_cat+1
                    }
                }
                
                let seating1 = Seating(categories: eventAvailCat, price: eventAvailPrice, noSeatsAvail: eventAvailSeats , noCategories: no_avail_cat)
                
                let event1 = Event(artist: eventArtist as! String, location: eventLocation as! String, datetime: eventDate as! String, description: nil, photo: nil, seating: seating1, time: eventTime as! String, artist_ranking: eventArtistRanking as! Int, day_in_week: eventDayinWeek as! String, event_ID: eventID as! String, event_status: eventStatus as! String, venue: eventVenue as! String, genre: eventGenre as! String, month: eventMonth as! String, timezone: eventTimezone as! String, city: eventCity as! String, imageURL: eventImageURL as! String, address: eventAddress as! String, weekend: eventWeekend as! String)
                
                self.events.append(event1!)
            }
            if self.isFiltering{
                self.filterContentofEvents(contextContent: self.filteredItems)
                print("SUCCESS!")
               
            }   else{
            self.tableView.reloadData()
            }
            //Code to execute to obtain the information held in the value field in the database
        })
    }
    
    func filterContentofEvents(contextContent: Dictionary<String, Any>){
        //reset to populate new events
        filteredEvents = events
        
        
        if let artist = contextContent["artist"] as? String{
            filteredEvents = filteredEvents.filter({( event:Event) -> Bool in
                return event.artist.lowercased().contains(artist.lowercased())
            })
        }
        if let location = contextContent["location"] as? String{
            filteredEvents = filteredEvents.filter({( event:Event) -> Bool in
                return event.location.lowercased().contains(location.lowercased())
            })
        }
        if let venue  = contextContent["venue"] as? String{
            filteredEvents = filteredEvents.filter({( event:Event) -> Bool in
                return event.venue.lowercased().contains(venue.lowercased())
            })
        }
        if let genre = contextContent["genre"] as? String{
            filteredEvents = filteredEvents.filter({( event:Event) -> Bool in
                return event.genre.lowercased().contains(genre.lowercased())
            })
        }
        if let start_date = contextContent["start_date"] as? Date{
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd hh:mm a"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            dateformatter.timeZone = TimeZone(abbreviation: "GMT")
            
            //range of dateas
            if let end_date = contextContent["end_date"] as? Date{
                filteredEvents = filteredEvents.filter{
                    let dateTime = $0.datetime + " " + $0.time
                    let eventDate = dateformatter.date(from: dateTime)
                    return(eventDate!.isBetween(start_date, and: end_date))
                }
            }
            else{
                filteredEvents = filteredEvents.filter{
                    let eventDate = dateformatter.date(from: $0.datetime)
                    return eventDate == (start_date)
                }
            }
            
        }
        
      
        tableView.reloadData()
    }
}
extension EventViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
}

extension Date{
    func isBetween(_ date1: Date, and date2: Date) -> Bool{
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}



