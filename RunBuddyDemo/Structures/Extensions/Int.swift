//
//  Int.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/27/24.
//

import Foundation


extension Int {
    
    // Converts Unix timestamp to Date in local timezone and returns formatted string
    var toLocalDateString: String {
        let utcDate = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
       
        return formatter.string(from: utcDate)
    }
    
    
    // Converts Unix timestamp to Date in local timezone and returns formatted string
    var toLocalTimeString: String {
        let utcDate = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current //shows the time of other places in my current system timezone.
        //formatter.timeZone = TimeZone(identifier: "Pacific/Honolulu")
       
        return formatter.string(from: utcDate)
    }
    
}
