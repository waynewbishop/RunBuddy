//
//  Date.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/4/24.
//

import Foundation

extension Date {
        
    //determines if supplied date falls within a 5 day range.
    func isWithinFiveDays(of date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: date)
        let dayDifference = abs(components.day ?? 0)
        return dayDifference <= 5
    }
    
    //advances the current date by the speicied parameter
    func advanceDays(by days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    //obtains the time from the specified date
    func extractTime() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm:ss" // Set the desired time format
           return formatter.string(from: self)
    }
    
    //determines if the specicied date comes before the current date
    func isDateAfterToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if self >= today {
            return true
        } else {
            return false
        }
    }
    
    //converts date to current timezone
    func toString(formatString: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .current) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = formatString
       formatter.timeZone = timeZone
        
       return formatter.string(from: self)
    }
       
    //convert a UTC date string to a Date object
   static func fromUTCString(_ dateString: String, formatString: String = "yyyy-MM-dd HH:mm:ss Z") -> Date? {
       let formatter = DateFormatter()
       formatter.dateFormat = formatString
       formatter.timeZone = TimeZone(abbreviation: "UTC")
       
       return formatter.date(from: dateString)
   }
    
    
}
