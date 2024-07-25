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

//sample weather data for testing
extension ChartForecast {
    static func generateTestData() -> [ChartForecast] {
        let baseDate = Calendar.current.startOfDay(for: Date())
        let timeIntervals = [2, 5, 8, 11, 14, 18, 20, 23] // Hours for 2AM, 5AM, 8AM, 11AM, 2PM, 6PM, 8PM, 11PM
        
        return timeIntervals.map { hour in
            let date = Calendar.current.date(byAdding: .hour, value: hour, to: baseDate)!
            return ChartForecast(
                dt: Int(date.timeIntervalSince1970),
                temp: Double.random(in: 15.0...30.0),
                feels_like: Double.random(in: 14.0...32.0),
                temp_min: Double.random(in: 12.0...20.0),
                temp_max: Double.random(in: 25.0...35.0),
                humidity: Int.random(in: 30...90),
                pop: Double.random(in: 0.0...1.0)
            )
        }
    }
}

