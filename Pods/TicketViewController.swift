//
//  TicketViewController.swift
//  Alamofire
//
//  Created by Morelli, Salem on 03/04/2018.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let artist = ["Drake", "Selena", "Beyonce"]
    
    
 //   @IBOutlet weak var artist: UIImageView!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var artistTab: UIView!
    
    @IBOutlet weak var artistLocation: UILabel!
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return (artist.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TicketTableViewCell"
        
     //   let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TicketTableView
            fatalError("The dequeued cell is not an instance of TicketTableViewCell.")
            
     //       cell.artist.image = UIImage(named: artist[indexPath.row] + ".jpg")
        
 
    //    return cell
        
    }

    override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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
}
