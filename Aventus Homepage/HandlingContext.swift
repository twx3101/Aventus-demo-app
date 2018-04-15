//
//  HandlingContext.swift
//  Aventus Homepage
//
//  Created by user137543 on 4/15/18.
//  Copyright © 2018 Krongsiriwat, Krantharat. All rights reserved.
//

import Foundation
import CapitoSpeechKit

class handlingContext{


    func bootstrapView(response: CapitoResponse){
        //print("bootstrapview")
        //process
        print("Response Code: %@", response.responseCode)
        print("Message Text: %@", response.message)
        print("Context: %@", response.context)
        print("Data: %@", response.data)
        
        
        //app-specific code to handle responses
        self.parseData(context: response.context)
    }
    
    func parseData(context: [AnyHashable : Any]){
        
        if let task = context["task"] as? String{
            if task == "Navigate"{
                //TODO
                
                contextContents.shared.contextContent = handleNavigate(context: context)
            }
            else if task == "BuyTicket"{
                //TODO
            }
            else if task == "SelectSeat"{
                //TODO
            }
            else if task == "NavigateStatic"{
                //TODO
            }
        }
        else{
            //handle nil data
            print("NIL Data")
        }
        contextContents.shared.context = context
    }
    
    func handleNavigate(context: [AnyHashable : Any]) -> [String : Any]{
        var contextContents = [String: Any]()
        //        artist: String
        if let artist = context["artist"] as? String{
            contextContents["artist"] = artist
            
        }
        //        location: String
        if let location = context["location"] as?  String{
            contextContents["location"] = location
        }
        
        //        venue: String
        if let venue = context["venue"] as? String{
            contextContents["venue"] = venue
        }
        
        //        genre: String
        if let genre = context["musicGenre"] as? String{
            contextContents["genre"] = genre
        }
        
        // handling time: AnyHashable("start_datetime")
        if let datetime = context["start_datetime"] as? [String : AnyObject]{
            let day = datetime["day"] as? Int
            let month = datetime["month"] as? Int
            let year = datetime["year"] as? Int
            
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let c = DateComponents(year: year, month: month, day: day )
            
            contextContents["start_date"] = cal.date(from: c)!
        }
        if let end_datetime = context["end_datetime"] as? [String: Int]{
            //if start_date is empty, set date to current time
            
            if contextContents.index(forKey: "start_datetime") == nil {
                contextContents["start_date"] = setCurrentDate()
            }
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            
            let end_day = end_datetime["day"]
            let end_month = end_datetime["month"]
            let end_year = end_datetime["year"]
            
            let d = DateComponents(year: end_year, month: end_month, day: end_day)
            
            contextContents["end_date"] = cal.date(from: d)
            
        }
        
        var daysToAdd = 0
        var monthsToAdd = 0
        var yearsToAdd = 0
        
        // Find events a period of time from current time
        if var end_week = context["end_week"] as? String{
            
            if end_week[end_week.startIndex] == "+"{
                end_week.remove(at: end_week.startIndex)
                let addWeekBy = Int(end_week)
                
                daysToAdd += addWeekBy! * 7
            }
        }
        
        if var end_day = context["end_day"] as? String{
            if end_day[end_day.startIndex] == "+"{
                end_day.remove(at: end_day.startIndex)
                let addDayBy = Int(end_day)
                
                daysToAdd = daysToAdd + addDayBy!
                
            }
        }
        
        if var end_month = context["end_month"] as? String{
            if end_month[end_month.startIndex] == "+"{
                end_month.remove(at: end_month.startIndex)
                let addMonthBy = Int(end_month)
                
                monthsToAdd = monthsToAdd + addMonthBy!
                
            }
        }
        
        if (daysToAdd != 0 || monthsToAdd != 0 || yearsToAdd != 0){
            // if no start date is set, set date to current day
            if contextContents.index(forKey: "start_datetime") == nil  {
                contextContents["start_date"] = setCurrentDate()
            }
            // set end date to current date + no. of days to add
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            let d = DateComponents(year: yearsToAdd, month: monthsToAdd, day: daysToAdd)
            
            let futureDate = cal.date(byAdding: d, to: start_date)
            
            contextContents["end_date"] = futureDate
        }
        // if there is no end_date, then set end_Date to the next day
        if contextContents.index(forKey: "end_date") == nil && contextContents.index(forKey: "start_date") != nil{
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            let d = DateComponents(day: 1)
            
            let futureDate = cal.date(byAdding: d, to: start_date)
            
            contextContents["end_date"] = futureDate
        }
        
        
        //handling time of day and hour
        if let dayPart = context["dayPart"] as? String{
            if contextContents.index(forKey: "start_datetime") == nil  {
                contextContents["start_date"] = setCurrentDate()
            }
            
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContents["start_date"] as! Date
            var d = DateComponents(hour: 0)
            var e = DateComponents(hour: 0)
            if dayPart == "Day"{
                d.hour = 6
                e.hour = 12
            }
            else if dayPart == "Afternoon"{
                d.hour = 12
                e.hour = 18
            }
            else if dayPart == "Night"{
                d.hour = 18
                e.hour = 24
            }
            let futureDate = cal.date(byAdding: d, to: start_date)
            let endDate = cal.date(byAdding: e, to: start_date)
            
            contextContents["start_date"] = futureDate
            contextContents["end_date"] = endDate
        }
        
        //handling price // not sure if this works
        if let amount = context["amount"] as? Int{
            contextContents["amount"] = amount
        }
        
        //need to handle context for this
        if let priceComparison = context["priceComparison"] as? String{
            contextContents["priceComparison"] = priceComparison
        }
        if let numTickets = context["numTickets"] as? Int{
            contextContents["numTickets"] = numTickets
        }
        if let ticketType = context["ticketType"] as? String{
            contextContents["ticketType"] = ticketType
        }
        
        if let seatArea = context["seatArea"] as? String{
            contextContents["seatArea"] = seatArea
        }
        
        
        return contextContents
        
    }
    
    func handleNavigateStatic(){
        //open help
    }
    
    func setCurrentDate() -> Date{
        let current_date = Date()
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "GMT")!
        
        var c = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: current_date)
        
        c.hour = 0
        c.minute = 0
        c.second = 0
        return cal.date(from: c)!
    }
}

//errors
