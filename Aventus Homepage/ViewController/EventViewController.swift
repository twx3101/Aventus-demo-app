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
import CapitoSpeechKit
import MBProgressHUD


// Event Page
class EventViewController: AVTBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIdentifier = "EventCollectionViewCell"
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var serverStatus: Bool = false
    
    var priceLimit : Double = 10
    
    var events = [Event]()
    var filteredEvents = [Event]()
    var isFiltering : Bool = false
    var filteredItems = Dictionary<String,Any>()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = colors.bg
        collectionView.backgroundColor = colors.bg
        
        definesPresentationContext = true
        
        self.textControl.delegate = self
        
        loadEvents()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // The number of events to be displayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEvents.count
        }
        return events.count
    }
    
    // How the events will be displayed
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "EventCollectionViewCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? EventCollectionViewCell else{
            fatalError("The dequeued cell is not an instance of EventCollectionViewCell.")
        }
        
        let event : Event
        if isFiltering{
            event = filteredEvents[indexPath.row]
        }
        else {
            event = events[indexPath.row]
        }

        let txtLabel = (event.artist).uppercased() + " " + event.location
        
        let mutableString = NSMutableAttributedString(string: txtLabel)
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: colors.bodyText, range: NSRange(location: 0, length: txtLabel.count))
        
        mutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Nexa Light", size: 21) as Any, range: NSRange(location: 0, length: event.artist.count))
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: colors.headerText, range: NSRange(location: 0, length: event.artist.count))
        
        cell.artistLabel.attributedText = mutableString
        
        cell.locationDatetimeLabel.text = event.formattedDate + ", " + event.time
        cell.locationDatetimeLabel.textColor = colors.bodyText
        
        cell.priceLabel.text = "From £" + String(Int(event.minPrice)) + " - " + String(Int(event.maxPrice))
        cell.priceLabel.font = UIFont(name:"Sarabun", size:24)
        
        cell.priceLabel.textColor = colors.bodyText

        Alamofire.request(event.bannerURL).responseImage { response in

            if let image = response.result.value{
                cell.artistPhoto.image = image
    
            }
        }

        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    
    // set the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSizeWidth = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)

        let itemSizeHeight: CGFloat = collectionView.frame.height / 3

        return CGSize(width: itemSizeWidth, height: itemSizeHeight)
    }
    
    
    // Navigate to Seat page when users select the event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pageViewController = self.parent as! PageViewController

        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        if isFiltering {
            detailViewController.eventLoaded = filteredEvents[indexPath.row]
        } else {
            detailViewController.eventLoaded = events[indexPath.row]
        }
        
        pageViewController.pages[3] = detailViewController
        
        pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // load events to be displayed
    private func loadEvents(){
        var blockchainEvents = [String]()
        let url = "http://localhost:8080/";
        
        //connect to Web3.js server to laod blockchain events
        Alamofire.request(url).responseJSON {
                        response in debugPrint(response)
                        if let json = response.result.value as? NSArray{
                            for event in json {
                                let i = event as? [String: Any]
                                let i2  = i!["eventdesc"] as! String
                                blockchainEvents.append(i2)
                                //      print(i2)
                            }
                            self.serverStatus = true
                        }
                        else{
                            //   print("Server offline")
                            self.serverStatus = false
                        }
                    }

        
        //Set the firebase reference
        ref = Database.database().reference()
        
        //Retrieve the posts and listen for changes
        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            
            //Getting information for events
            for event in snapshot.children.allObjects as![DataSnapshot]{
                let eventObject = event.value as? [String: AnyObject]
                let eventArtist = eventObject?["Events"]
                let eventDate = eventObject?["Local Date"]
                let eventFormattedDate = eventObject?["Local Date (uk format)"]
                let eventLocation = eventObject?["City"]
                let eventTime = eventObject?["Local Time (formatted)"]
                let eventDayinWeek = eventObject?["Day in week"]
                let eventArtistRanking = eventObject?["Artist Ranking"]
                let eventID = eventObject?["eventDesc"]
                let eventBannerURL = eventObject?["Fake Artist Banner"]
                let eventStatus = eventObject?["Event Status"]
                let eventVenue = eventObject?["Venue"]
                let eventGenre = eventObject?["Genre"]
                let eventMonth = eventObject?["Month"]
                let eventTimezone = eventObject?["Timezone"]
                let eventWeekend = eventObject?["Weekend"]
                var eventCatArea = [String]()
                
                let eventList = eventObject?["list"]
                
                eventCatArea.append(eventObject?["Area: category 5 Standing"] as! String)
                eventCatArea.append(eventObject?["Area: category 4"] as! String)
                eventCatArea.append(eventObject?["Area: category 3"] as! String)
                eventCatArea.append(eventObject?["Area: category 2"] as! String)
                eventCatArea.append(eventObject?["Area: category 1"] as! String)
                
                var eventCatPrice = [Double]()
                
                if let cat5 = eventObject?["Category 5(standing area): Price"] as? Double{ eventCatPrice.append(cat5)
                }
                else{
                    eventCatPrice.append(0)
                }
                
                if let cat4 = eventObject?["Category 4: Price"] as? Double{ eventCatPrice.append(cat4)
                }
                else{
                    eventCatPrice.append(0)
                }
                
                if let cat3 = eventObject?["Category 3: Price"] as? Double{ eventCatPrice.append(cat3)
                }
                else{
                    eventCatPrice.append(0)
                }

                if let cat2 = eventObject?["Category 2: Price"] as? Double{ eventCatPrice.append(cat2)
                }
                else{
                    eventCatPrice.append(0)
                }
                
                if let cat1 = eventObject?["Category 1: Price"] as? Double{ eventCatPrice.append(cat1)
                }
                else{
                    eventCatPrice.append(0)
                }
                
                
                var eventCatSeats = [Int]()
                
                if let seat5 = eventObject?["Category 5: Number of seat available"] as? Int{ eventCatSeats.append(seat5)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                if let seat4 = eventObject?["Category 4: Number of seat available"] as? Int{ eventCatSeats.append(seat4)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                if let seat3 = eventObject?["Category 3: Number of seat available"] as? Int{ eventCatSeats.append(seat3)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                if let seat2 = eventObject?["Category 2: Number of seat available"] as? Int{ eventCatSeats.append(seat2)
                }
                else{
                    eventCatSeats.append(0)
                }
                
                if let seat1 = eventObject?["Category 1: Number of seat available"] as? Int{ eventCatSeats.append(seat1)
                }
                else{
                    eventCatSeats.append(0)
                }

                

                var eventAvailCat = [String]()
                var eventAvailPrice = [Double]()
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
                
                let eventMinPrice = eventAvailPrice.min()
                let eventMaxPrice = eventAvailPrice.max()
                
                let seating1 = Seating(categories: eventAvailCat, price: eventAvailPrice, noSeatsAvail: eventAvailSeats , noCategories: no_avail_cat)
                
             
                if self.serverStatus == true {
                    if blockchainEvents.contains(eventID as! String) {
                        let event1 = Event(artist: eventArtist as! String, location: eventLocation as! String, datetime: eventDate as! String, formattedDate: eventFormattedDate as! String, seating: seating1, time: eventTime as! String, artist_ranking: eventArtistRanking as! Int, day_in_week: eventDayinWeek as! String, event_ID: eventID as! String, event_status: eventStatus as! String, venue: eventVenue as! String, genre: eventGenre as! String, month: eventMonth as! String, timezone: eventTimezone as! String, bannerURL: eventBannerURL as! String, weekend: eventWeekend as! String, minPrice: eventMinPrice as! Double, maxPrice: eventMaxPrice as! Double, event_list: eventList as! Int)
                        
                        
                        self.events.append(event1!)
                    }
                }
                else{
                    //server offlline
                    let event1 = Event(artist: eventArtist as! String, location: eventLocation as! String, datetime: eventDate as! String, formattedDate: eventFormattedDate as! String, seating: seating1, time: eventTime as! String, artist_ranking: eventArtistRanking as! Int, day_in_week: eventDayinWeek as! String, event_ID: eventID as! String, event_status: eventStatus as! String, venue: eventVenue as! String, genre: eventGenre as! String, month: eventMonth as! String, timezone: eventTimezone as! String, bannerURL: eventBannerURL as! String, weekend: eventWeekend as! String, minPrice: eventMinPrice as! Double, maxPrice: eventMaxPrice as! Double, event_list: eventList as! Int)
                    
                    
                    self.events.append(event1!)
                }
            }
            if self.isFiltering{
                self.filterContentofEvents(contextContent: self.filteredItems)
                if self.filteredEvents.count == 0{
                    handlingContext.resetData()
                    helper.showAlert(message: "Sorry, I could not find any events")
                }
               
            } else{
                self.collectionView.reloadData()
            }
        })
    }
    
    func filterContentofEvents(contextContent: Dictionary<String, Any>) -> Int{
        var newEvents = events
        
        if let artist = contextContent["artist"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return event.artist.lowercased().contains(artist.lowercased())
            })
        }
        if let location = contextContent["location"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return event.location.lowercased().contains(location.lowercased())
            })
        }
        if let venue  = contextContent["venue"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return event.venue.lowercased().contains(venue.lowercased())
            })
        }
        if let genre = contextContent["genre"] as? String{
            
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return
               (event.genre.lowercased().replacingOccurrences(of: "/", with: " ")).contains(genre.lowercased())
            })
        }
        if let start_date = contextContent["start_date"] as? Date{
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy hh:mm a"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            dateformatter.timeZone = TimeZone(abbreviation: "GMT")
            
            //range of dateas
            if let end_date = contextContent["end_date"] as? Date{
                print(start_date, end_date, "hello4")
                newEvents = newEvents.filter{
                    let dateTime = $0.datetime + " " + $0.time
                    let eventDate = dateformatter.date(from: dateTime)
                    return(eventDate!.isBetween(start_date, and: end_date))
                }
            }
            else{
                newEvents = newEvents.filter{
                    let eventDate = dateformatter.date(from: $0.datetime)
                    return eventDate == (start_date)
                }
            }
            
        }
        
        if let amount = contextContent["amount"] as? Double{
            print("HELLO", amount)
            if let priceComparison = contextContent["priceComparison"] as? String{
                print("HELLO2", priceComparison)
                switch priceComparison {
                case "<=" :
                    newEvents = newEvents.filter{
                        return $0.minPrice <= amount
                    }
                case "<" :
                    newEvents = newEvents.filter{
                        return $0.minPrice < amount
                    }
                case ">" :
                    newEvents = newEvents.filter{
                        return $0.minPrice > amount
                    }
                case ">=" :
                    newEvents = newEvents.filter{
                        return $0.minPrice >= amount
                    }
                case "~" :
                    newEvents = newEvents.filter{
                        return ($0.minPrice <= amount + priceLimit && $0.minPrice >= amount - priceLimit)
                    }
                case "=" :
                    newEvents = newEvents.filter{
                        return $0.minPrice == amount
                    }
                default:
                    print("Unknown price comparison operator")
                }
            }
            else {
                newEvents = newEvents.filter{
                    return $0.minPrice <= amount
                }
            }
        }
        print(newEvents.count, "count")
        if newEvents.count > 0{
            filteredEvents = newEvents
            collectionView.reloadData()
            print("Hello, i did reload")
            collectionView.setContentOffset(.zero, animated: true)
            return newEvents.count
        }
        else{
            helper.showAlert(message: "Sorry I couldn't find any events")
            return 0
        }
    }
    
    func excludeContentofEvents(contextContent: Dictionary<String, Any>){
        var newEvents : [Event]
        if self.isFiltering{
            newEvents = filteredEvents
        }
        else{
            newEvents = events
        }
        
        if let artist = contextContent["artist"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return !(event.artist.lowercased().contains(artist.lowercased()))
            })
        }
        if let location = contextContent["location"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return !(event.location.lowercased().contains(location.lowercased()))
            })
        }
        if let venue  = contextContent["venue"] as? String{
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return !(event.venue.lowercased().contains(venue.lowercased()))
            })
        }
        if let genre = contextContent["genre"] as? String{
            
            newEvents = newEvents.filter({( event:Event) -> Bool in
                return !(event.genre.lowercased().replacingOccurrences(of: "/", with: " ")).contains(genre.lowercased())
            })
        }
        if let start_date = contextContent["start_date"] as? Date{
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy hh:mm a"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            dateformatter.timeZone = TimeZone(abbreviation: "GMT")
            
            //range of dateas
            if let end_date = contextContent["end_date"] as? Date{
                print(start_date, end_date, "hello4")
                newEvents = newEvents.filter{
                    let dateTime = $0.datetime + " " + $0.time
                    let eventDate = dateformatter.date(from: dateTime)
                    return !(eventDate!.isBetween(start_date, and: end_date))
                }
            }
            else{
                newEvents = newEvents.filter{
                    let eventDate = dateformatter.date(from: $0.datetime)
                    return eventDate != (start_date)
                }
            }
            
        }
        
        self.isFiltering = true
        filteredEvents = newEvents
        collectionView.reloadData()
        print("Hello, i did reload")
        collectionView.setContentOffset(.zero, animated: true)
    }
    
}

// Context is handled differently by the page
extension EventViewController{
    
    override func handle(response: CapitoResponse){
        if response.messageType == "WARNING"{
        }
        else{
            handlingContext().bootstrapView(response: response)
            if let task = response.semanticOutput["task"] as? String{
                if task == "NavigateStatic"{
                    if let goTo = response.semanticOutput["goTo"] as? String{
                        if goTo == "help"{
                            navHelp()
                        }
                        else if goTo == "MyPurchases"{
                            navTicket()
                        }
                        else if goTo == "Homepage"{
                             let pageViewController = self.parent as! PageViewController
                            let nextViewController = pageViewController.pages[1] as! HomeViewController
                            pageViewController.setViewControllers([nextViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                        }
                    }
                }
                else if task == "Navigate"{
                    self.isFiltering = true
                    self.filteredItems = contextContents.shared.contextContent
                    self.filterContentofEvents(contextContent: self.filteredItems)
                    self.collectionView.reloadData()
                }
                
                else if task == "BuyTicket" || task == "BuyTickets"{
                    handleBuyTickets()
                }
                else if task == "Cancel"{
                    self.isFiltering = false
                    self.collectionView.reloadData()
                }
                else if task == "Exclude"{
                    self.excludeContentofEvents(contextContent: contextContents.shared.contextContent)
                }
            }
            else{
                helper.showAlert(message: "Sorry, I couldn't understand that!")
            }
        }
    }
    
    override func handleBuyTickets(){
        var categoryNum : Int?
        var number: Int?
        
        self.isFiltering = true
        self.filteredItems = contextContents.shared.contextContent
        let x = (self.filterContentofEvents(contextContent: self.filteredItems))
        if x == 0{
            helper.showAlert(message: "Sorry I couldn't find  any events")
            return
        }
        
        let pageViewController = self.parent as! PageViewController
       
        let noOfEvents = self.filteredEvents
        
        //instatiated ticket buying page
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        pageViewController.pages[3] = detailViewController
        
        if let numTickets = contextContents.shared.contextContent["numTickets"] as? String{
            
            number = Int(numTickets)
            detailViewController.selectedTicket = number!
            
        }
        if let category = contextContents.shared.contextContent["seatArea"] as? String{
            
            switch category{
            case "A":
                categoryNum = 1
            case "B":
                categoryNum = 2
            case "C":
                categoryNum = 3
            case "D":
                categoryNum = 4
            case "Standing":
                categoryNum = 0
            default:
                categoryNum = 0
            }
            detailViewController.category = categoryNum!
        }
        
        if noOfEvents.count == 1{

            if number != nil && categoryNum != nil{
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                
                let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
                
                pageViewController.pages[4] = paymentViewController
                paymentViewController.event = detailViewController.eventLoaded
                let selectedCategories = detailViewController.categoriesData[categoryNum!]
                let selectedPrice = detailViewController.priceData[categoryNum!]
                let price = Double(selectedPrice)
                
                
                paymentViewController.payment = Payment(category: selectedCategories, price: price!, selectedSeats: number!)
                
                pageViewController.setViewControllers([paymentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
            else if number != nil{
                
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                helper.showAlert(message: "Please select a seat category")
            }
            else if categoryNum != nil{
                
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                helper.showAlert(message: "Please select the number of seats")
            }
            else{
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                helper.showAlert(message: "Please select your seat")
            }
        }
            
        //go back to event page  if there's more than 1 event to select from
        else{
            helper.showAlert(message: "Which event would you like to go to?")

        }
    }
    
}


extension EventViewController{
    
    override func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        self.showProcessingHUD(text: "Processing...")
    }
    
    override func speechControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    override func speechControllerDidFinishWithError(_ error: Error!) {
        self.hideProcessingHUD()
        //self.showError(error)
    }
}

extension Date{
    func isBetween(_ date1: Date, and date2: Date) -> Bool{
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}


