//
//  String.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/4/24.
//

import Foundation

extension String {
    
    //present date in long string format    
    var headingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: self) else {
            return "Invalid Date"
        }
        
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    func truncated(maxLength: Int = 15) -> String {
       if count <= maxLength {
           return self
       } else {
           let truncatedString = String(prefix(maxLength - 3))
           return truncatedString + "..."
       }
   }
    
}

