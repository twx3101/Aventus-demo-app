//
//  PageViewController.swift
//  Aventus Homepage
//
//  Created by Krongsiriwat, Krantharat on 05/03/2018.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//





import UIKit

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
        
        setViewControllers([homePage], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!

        if cur == pageNo.home || cur == pageNo.confirm {
            return nil
        }
        
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
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
