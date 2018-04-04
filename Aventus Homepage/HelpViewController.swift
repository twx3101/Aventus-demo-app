//
//  HelpViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 04/04/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    var pageVC: PageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.bg

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
    @IBAction func goHome(_ sender: RoundButton) {
        //let pageViewController = parent as! PageViewController
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as! ViewController
        
        pageVC?.pages[1] = homeViewController
        
        pageVC?.setViewControllers([homeViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
}
