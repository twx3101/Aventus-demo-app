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


class EventViewController: AVTBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mic2: UIButton!
    @IBOutlet weak var textControl2: UITextField!
    
    lazy var readyMic: UIImage = {
        return UIImage(named: "icons8-microphone-96")!
    }()
    lazy var pressedMic: UIImage = {
        return UIImage(named: "microphone_on")!
    }()
    
    let cellIdentifier = "EventCollectionViewCell"
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
 
    var isRecording : Bool = false
    var priceLimit : Double = 10
    
    var events = [Event]()
    var filteredEvents = [Event]()
    var isFiltering : Bool = false
    var filteredItems = Dictionary<String,Any>()
    let searchController = UISearchController(searchResultsController: nil)
    
    var menuTap: UITapGestureRecognizer!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEvents.count
        }
        return events.count
    }
    
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
        
        cell.priceLabel.textColor = colors.bodyText

        Alamofire.request(event.bannerURL).responseImage { response in
            debugPrint(response)

            if let image = response.result.value{
                cell.artistPhoto.image = image
    
            }
        }

        cell.layer.cornerRadius = 15.0
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSizeWidth = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)

        let itemSizeHeight: CGFloat = collectionView.frame.height / 3

        return CGSize(width: itemSizeWidth, height: itemSizeHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("clicked")
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = colors.bg
        collectionView.backgroundColor = colors.bg
        // Do any additional setup after loading the view.
        // Load events to display
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            //tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        //self.textControl2.delegate = self
        self.textControl.delegate = self
        
        
        menuButton.addTarget(self, action: #selector(showMenu), for:    .touchUpInside)
        
        
        loadEvents()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenu() {
        
        showMenuBase()
        
        menuTap = UITapGestureRecognizer(target: self, action: #selector(hideMenu(_:)))
        view.addGestureRecognizer(menuTap)
        
        mic2.isEnabled = false
        
    }
    
    @objc func hideMenu(_ tap: UITapGestureRecognizer) {
    
        hideMenuBase()
        
        view.removeGestureRecognizer(menuTap)
        mic2.isEnabled = true
        
        collectionView.isUserInteractionEnabled = true
        
    }

    @IBAction func help(_ sender: UIButton) {
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "HelpPage") as! HelpViewController
        
        let pageViewController = self.parent as! PageViewController
        
        detailViewController.pageIndex = pageViewController.pages.index(of: self)
        
        present(detailViewController, animated: true, completion: nil)
    }
    
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
        collectionView.reloadData()
        //tableView.reloadData()
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
                let eventFormattedDate = eventObject?["Local Date (uk format)"]
                let eventLocation = eventObject?["Fake City"]
                let eventTime = eventObject?["Local Time (formatted)"]
                let eventDayinWeek = eventObject?["Day in week"]
                
                let eventArtistRanking = eventObject?["Artist Ranking"]
                
                let eventID = eventObject?["Event ID"]

                let eventImageURL = eventObject?["Fake Artist Pc JPEG URL"]
                let eventBannerURL = eventObject?["Fake Artist Banner"]

                let eventStatus = eventObject?["Event Status"]
                
                let eventVenue = eventObject?["Fake Venue"]
                let eventGenre = eventObject?["Genre"]
                let eventMonth = eventObject?["Month"]
                let eventTimezone = eventObject?["Timezone"]
                let eventAddress = eventObject?["Venue address"]
                let eventCity = eventObject?["Venue city"]
                let eventWeekend = eventObject?["Weekend"]
                
                
                
                var eventCatArea = [String]()
                
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

                if let cat2 = eventObject?["Category : Price"] as? Double{ eventCatPrice.append(cat2)
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
                
                let event1 = Event(artist: eventArtist as! String, location: eventLocation as! String, datetime: eventDate as! String, formattedDate: eventFormattedDate as! String, description: nil, photo: nil, seating: seating1, time: eventTime as! String, artist_ranking: eventArtistRanking as! Int, day_in_week: eventDayinWeek as! String, event_ID: eventID as! String, event_status: eventStatus as! String, venue: eventVenue as! String, genre: eventGenre as! String, month: eventMonth as! String, timezone: eventTimezone as! String, city: eventCity as! String, imageURL: eventImageURL as! String, bannerURL: eventBannerURL as! String, address: eventAddress as! String, weekend: eventWeekend as! String, minPrice: eventMinPrice as! Double, maxPrice: eventMaxPrice as! Double)
                
                
                self.events.append(event1!)
            }
            if self.isFiltering{
                self.filterContentofEvents(contextContent: self.filteredItems)
                print("SUCCESS!")
               
            }   else{
                self.collectionView.reloadData()
            //self.tableView.reloadData()
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
                return genre.lowercased().contains(event.genre.lowercased().replacingOccurrences(of: "/", with: " "))
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
        
        if let amount = contextContent["amount"] as? Double{
            print("HELLO", amount)
            if let priceComparison = contextContent["priceComparison"] as? String{
                print("HELLO2", priceComparison)
                switch priceComparison {
                    case "<=" :
                        filteredEvents = filteredEvents.filter{
                            return $0.minPrice <= amount
                    }
                    case "<" :
                        filteredEvents = filteredEvents.filter{
                            return $0.minPrice < amount
                        }
                    case ">" :
                        filteredEvents = filteredEvents.filter{
                            return $0.minPrice > amount
                        }
                    case ">=" :
                        filteredEvents = filteredEvents.filter{
                            return $0.minPrice >= amount
                        }
                    case "~" :
                        filteredEvents = filteredEvents.filter{
                            return ($0.minPrice <= amount + priceLimit && $0.minPrice >= amount - priceLimit)
                        }
                    case "=" :
                        filteredEvents = filteredEvents.filter{
                            return $0.minPrice == amount
                        }
                    default:
                        print("Unknown price comparison operator")
                    }
            }
            else {
                filteredEvents = filteredEvents.filter{
                    return $0.minPrice <= amount
                }
            }
        }
        
        collectionView.reloadData()
        print("Hello, i did reload")
        //tableView.reloadData()
    }
    
    @IBAction func MicrophonePress(_ sender: UIButton) {
        
        if self.isRecording {
            CapitoController.getInstance().cancelTalking()
            print("if")
        }
        else {
            CapitoController.getInstance().push(toTalk: self, withDialogueContext: contextContents.shared.context)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //if let text = self.textControl2.text{
        if let text = self.textControl.text {
            print("Sending Text event:\(text)")
            self.handle(text: text)
            
        }
        textField.text = ""
        return true
    }
}

extension EventViewController{
    func handle(text:String){
        self.showProcessingHUD(text: "Processing...")
        
        CapitoController.getInstance().text(self, input: text, withDialogueContext: contextContents.shared.context)
    }
    
    func handle(response: CapitoResponse){
        //print("handle")
        if response.messageType == "WARNING"{
            //self.showErrorMessage(text: response.message)
        }
        else{
            handlingContext().bootstrapView(response: response)
            if let task = response.context["task"] as? String{
                self.isFiltering = true
                self.filteredItems = contextContents.shared.contextContent
                self.filterContentofEvents(contextContent: self.filteredItems)
                self.collectionView.reloadData()
                
                if task == "BuyTicket" || task == "BuyTickets"{
                    handleBuyTickets()
                }
            }
        }
    }
    
    func handleBuyTickets(){
        var categoryNum : Int?
        var number: Int?
        
        let pageViewController = self.parent as! PageViewController
       
        let noOfEvents = self.filteredEvents
        
        //instatiated ticket buying page
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatPage") as! SeatViewController
        
        pageViewController.pages[3] = detailViewController
        
        if let numTickets = contextContents.shared.contextContent["numTickets"] as? String{
            
            number = Int(numTickets)
            detailViewController.selectedTicket = number!
            
        }
        if let category = contextContents.shared.contextContent["ticketType"] as? String{
            
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
        
        print("HELLO2")
        
        if noOfEvents.count == 1{
            print("Hello3", noOfEvents.count)
            
            if number != nil && categoryNum != nil{
                let paymentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentViewController
                
                pageViewController.pages[4] = paymentViewController
                paymentViewController.event = detailViewController.eventLoaded
                let selectedCategories = detailViewController.categoriesData[categoryNum!]
                let selectedPrice = detailViewController.priceData[categoryNum!]
                let price = Double(selectedPrice)
                
                
                paymentViewController.payment = Payment(category: selectedCategories, price: price!, selectedSeats: number!)
            }
            else if number != nil{
                
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
            else if categoryNum != nil{
                detailViewController.eventLoaded = self.filteredEvents[0]
                pageViewController.setViewControllers([detailViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
        }
        else if noOfEvents.count == 0{
            //TODO
        
        }
            
            //go back to event page  if there's more than 1 event to select from
        else{
           //print message
        }
    }
    
}


extension EventViewController{
    
    func showProcessingHUD(text: String){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.minShowTime = 1.0
        hud.label.text = "Processing"
        hud.detailsLabel.text = text
    }
    func hideProcessingHUD(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}

extension EventViewController: SpeechDelegate{
    
    func speechControllerDidBeginRecording() {
        self.isRecording = true
        //change microphone to show busy recording
        self.mic2.setImage(pressedMic, for: .normal)
    }
    
    func speechControllerDidFinishRecording() {
        self.isRecording = false
        self.mic2.setImage(readyMic, for: .normal)
    }
    
    func speechControllerProcessing(_ transcription: CapitoTranscription!, suggestion: String!) {
        self.showProcessingHUD(text: "Processing...")
    }
    
    func speechControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    func speechControllerDidFinishWithError(_ error: Error!) {
        self.hideProcessingHUD()
        self.showError(error)
    }
}

/*
 extension ViewController: UISearchBarDelegate {
 func searchButtonPressed(_ searchBar: UISearchBar){
 self.textControlBar.resignFirstResponder()
 
 if let text = searchBar.text{
 print("Sending text event: \(text)")
 self.onTextControlClick(nil)
 self.handle(text: text)
 }
 }
 }
 */
extension EventViewController: TextDelegate{
    func textControllerDidFinish(withResults response: CapitoResponse!) {
        self.hideProcessingHUD()
        self.handle(response: response)
    }
    
    func textControllerDidFinishWithError(_ error: Error!){
        self.hideProcessingHUD()
        self.showError(error)
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


