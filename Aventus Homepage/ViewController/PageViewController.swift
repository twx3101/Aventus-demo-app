//
//  PageViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//





import UIKit

// PageViewController is the initial view controller of the application and helps manage navigation between pages
// It consists of 1) Ticket 2) Home 3) Event 4) Seat 5) Payment 6) Confirm
// This is set to show Home Page when called
class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    var instantiated = [Bool](repeating: false, count: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let ticketPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "TicketPage")
        let homePage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "HomePage")
        let eventPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "EventPage")
        let seatPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "SeatPage")
        let paymentPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "PaymentPage")
        let confirmPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ConfirmPage")
        
        pages.append(ticketPage)
        pages.append(homePage)
        pages.append(eventPage)
        pages.append(seatPage)
        pages.append(paymentPage)
        pages.append(confirmPage)
        
        // set the first page
        setViewControllers([homePage], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    // Go to the previous page by swiping left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // From home and confirm page, the application does not allow users to go to the previous page
        if cur == pageNo.home || cur == pageNo.confirm {
            return nil
        }
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
        
    }
    
    // Go to the next page by swiping right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // If users stay at Seat, Payment and Confirm, the application does not allow users to go to the next page by swiping
        if cur >= pageNo.event {
            return nil
        }
        
        let nxt = abs((cur + 1) % pages.count)
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
}
