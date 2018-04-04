//
//  EventCollectionViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class EventCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var labels = ["label1", "label2", "label3"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! UICollectionViewCell
        
        print(cell.bounds.size.width)
        print(cell.bounds.size.height)
        
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        cell.contentView.addSubview(title)
        title.text = labels[indexPath.row]
        title.textColor = UIColor.yellow
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

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
