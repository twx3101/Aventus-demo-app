//
//  EventTableViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 03/02/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    // MARK: Properties
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load events to display
        loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else{
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        let event = events[indexPath.row]
        
        cell.artistLabel.text = event.artist
        cell.locationAndDateTime.text = event.location + " " + event.datetime
        cell.descriptionLabel.text = event.description
        cell.artistPhoto.image = event.photo
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
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
        
        guard let event1 = Event(artist: "Drake", location: "London", datetime: "today", description: nil, photo: photo1) else{
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(artist: "Selena", location: "London", datetime: "tomorrow", description: nil, photo: photo2) else{
            fatalError("Unable to instantiate event2")
        }
        
        guard let event3 = Event(artist: "Selena", location: "London", datetime: "next week", description: nil, photo: photo2) else{
            fatalError("Unable to instantiate event3")
        }
        
        events += [event1, event2, event3]
        
    }
    
}
