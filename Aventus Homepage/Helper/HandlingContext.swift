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
        //print("Response Code: %@", response.responseCode)
        print("Message Text: %@", response.message)
        print("This is Context: %@", response.context)
        print("This is Data: %@", response.semanticOutput)
        
                //app-specific code to handle responses
       
        self.parseData(context: response.semanticOutput)
        if contextContents.shared.context == nil{
            contextContents.shared.context = response.semanticOutput
        }
        else{
            contextContents.shared.context = response.context
        }

    }
    
    func parseData(context: [AnyHashable : Any]){
        
        if let task = context["task"] as? String{
            if task == "Navigate"{
                //TODO
                
                contextContents.shared.contextContent = handleNavigate(context: context)
            }
            else if task == "BuyTicket" || task == "BuyTickets"{
                //TODO
                 contextContents.shared.contextContent = handleNavigate(context: context)
            }
//            else if task == "SelectSeat"{
//                //TODO
//            }
//            else if task == "NavigateStatic"{
//                //TODO
//            }
        }
        else{
            //handle nil data
            print("NIL Data")
        }
        
    }
    
    func handleNavigate(context: [AnyHashable : Any]) -> [String : Any]{
        var contextContent = contextContents.shared.contextContent
        //        artist: String
        if let artist = context["artist"] as? String{
            if (contextContent["genre"] as? String) != nil{
                handlingContext.resetData()
                contextContent = contextContents.shared.contextContent
            }
            if let compArtist = contextContent["artist"] as? String{
                if artist != compArtist{
                    handlingContext.resetData()
                    contextContent = contextContents.shared.contextContent
                }
            }
            
            contextContent["artist"] = artist
            
        }
        //        genre: String
        if let genre = context["musicGenre"] as? String{
            if (contextContent["artist"] as? String) != nil{
                handlingContext.resetData()
                contextContent = contextContents.shared.contextContent
            }
            contextContent["genre"] = genre
        }
        //        location: String
        if let location = context["location"] as?  String{
           
            if (contextContent["venue"] as? String) != nil{
                handlingContext.resetData()
                contextContent = contextContents.shared.contextContent
            }
             contextContent["location"] = location
        }
        
        //        venue: String
        if let venue = context["venue"] as? String{
            contextContent["venue"] = venue
            if (contextContent["location"] as? String) != nil{
                handlingContext.resetData()
                contextContent = contextContents.shared.contextContent
            }
        }
        
  
  
        // handling time: AnyHashable("start_datetime")
        if let datetime = context["start_datetime"] as? [String : AnyObject]{
            let day = datetime["day"] as? Int
            let month = datetime["month"] as? Int
            let year = datetime["year"] as? Int
            
            if let hour = datetime["hour"] as? Int{
                let minute = datetime["minute"] as? Int
                var cal = Calendar.current
                cal.timeZone = TimeZone(abbreviation: "GMT")!
                let c = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute )
                print(cal.date(from: c)!, "hello2")
                contextContent["start_date"] = cal.date(from: c)!
            }
            else{
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let c = DateComponents(year: year, month: month, day: day )
            print(cal.date(from: c)!, "hello2")
            contextContent["start_date"] = cal.date(from: c)!
            }
        }
        if let end_datetime = context["end_datetime"] as? [String: Int]{
            //if start_date is empty, set date to current time
            
            if contextContent.index(forKey: "start_date") == nil {
                contextContent["start_date"] = setCurrentDate()
            }
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            
            let end_day = end_datetime["day"]
            let end_month = end_datetime["month"]
            let end_year = end_datetime["year"]
            if let hour = end_datetime["hour"] as? Int{
                let minute = end_datetime["minute"] as? Int
                let d = DateComponents(year: end_year, month: end_month, day: end_day, hour: hour, minute: minute )
                print(cal.date(from: d)!, "hello2")
                contextContent["end_date"] = cal.date(from: d)!
            }
            else{
            let d = DateComponents(year: end_year, month: end_month, day: end_day, hour: 23, minute: 59, second: 59)
            print(cal.date(from: d)!, "hello3")
            contextContent["end_date"] = cal.date(from: d)
            }
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
            
            contextContent["start_date"] = setCurrentDate()
            
            // set end date to current date + no. of days to add
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContent["start_date"] as! Date
            let d = DateComponents(year: yearsToAdd, month: monthsToAdd, day: daysToAdd)
            
            let futureDate = cal.date(byAdding: d, to: start_date)
            
            contextContent["end_date"] = futureDate
        }
        // if there is no end_date, then set end_Date to the next day
        if contextContent.index(forKey: "end_date") == nil && contextContent.index(forKey: "start_date") != nil{
            var cal = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "GMT")!
            let start_date = contextContent["start_date"] as! Date
            let d = DateComponents(day: 1)
            
            let futureDate = cal.date(byAdding: d, to: start_date)
            
            contextContent["end_date"] = futureDate
        }
        
        
        //handling time of day and hour
//        if let dayPart = context["dayPart"] as? String{
//            if contextContent.index(forKey: "start_date") == nil  {
//                contextContent["start_date"] = setCurrentDate()
//            }
//
//            var cal = Calendar.current
//            cal.timeZone = TimeZone(abbreviation: "GMT")!
//            let start_date = contextContent["start_date"] as! Date
//            var d = DateComponents(hour: 0)
//            var e = DateComponents(hour: 0)
//            if dayPart == "Day"{
//                d.hour = 6
//                e.hour = 12
//            }
//            else if dayPart == "Afternoon"{
//                d.hour = 12
//                e.hour = 18
//            }
//            else if dayPart == "Night"{
//                d.hour = 18
//                e.hour = 24
//            }
//            let futureDate = cal.date(byAdding: d, to: start_date)
//            let endDate = cal.date(byAdding: e, to: start_date)
//
//            contextContent["start_date"] = futureDate
//            contextContent["end_date"] = endDate
//        }
//
        //handling price // not sure if this works
        if let amount = context["amount"] as? String{
            print("HELLO3", amount)
            contextContent["amount"] = Double(amount)
            
        }
        
        //need to handle context for this
        if let priceComparison = context["priceComprison"] as? String{
            print("HELLO4", priceComparison)
            contextContent["priceComparison"] = priceComparison
            
        }
        if let numTickets = context["numTickets"] as? String{
            contextContent["numTickets"] = numTickets
        }
//        if let ticketType = context["ticketType"] as? String{
//            contextContent["ticketType"] = ticketType
//        }
        
        if let seatArea = context["seatArea"] as? String{
            contextContent["seatArea"] = seatArea
        }
        
        
        return contextContent
        
    }
//
//    func handleNavigateStatic(){
//        //open help
//    }
//
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
    
    static func resetData(){
        print("Data Reset")
        contextContents.shared.context = nil
        contextContents.shared.contextContent = [String:Any]()
    }
}

//errors
