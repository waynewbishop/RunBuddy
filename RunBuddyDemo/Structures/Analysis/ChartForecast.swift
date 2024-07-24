//
//  ChartForecast.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/19/24.
//

import Foundation
import CoreLocation


/// Structure used in charting and analysis
struct ChartForecast: Identifiable, Equatable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    let pop: Double 
    
    // Use the 'dt' property as the identifier
    var id: Int {
       return dt
    }
    
    //converts to date format
    var date: Date {
        let interval_date = Date(timeIntervalSince1970: TimeInterval(dt))
        return interval_date
    }
    
    //equatable conformance
    static func == (lhs: ChartForecast, rhs: ChartForecast) -> Bool {
        return lhs.dt == rhs.dt &&
               lhs.temp == rhs.temp &&
               lhs.feels_like == rhs.feels_like &&
               lhs.temp_min == rhs.temp_min &&
               lhs.temp_max == rhs.temp_max &&
               lhs.humidity == rhs.humidity &&
               lhs.pop == rhs.pop
    }
    
}


