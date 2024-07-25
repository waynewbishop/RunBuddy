//
//  PromptModel.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/19/24.
//

import Foundation
import CoreLocation

struct Prompt {
    
    //create a prompt based on weather requirements
    func promptForecast(weather forecasts: [ChartForecast], city: String, targetDate: String) -> String {
        
        let finalPrompt = """
        User: I am planning a run today. Preferably, I'd like to avoid running in extreme heat, humidity or rain. This includes avoiding running in temperatures above 80 degrees Fahrenheit and humidity levels above 80%. The response should provide a single 30 to 40 word paragraph. Assume I want to run during daylight hours. Do not provide any recommendations for clothing, hydration or nutrition. Any forecasted precipitation or humidity should be treated as a continuous function between each time interval. For example, for any two time points t1 and t2 where precipitation or humidity is forecasted, assume P(t) is continuous for all t between t1 and t2. Any references to times should be in 12-hour format not 24-hour format. The general tone of the response should be upbeat, positive and encouraging. When required, only refer to yourself in first person. Do not use any titles or sub headings in the response. Any numerical values provided in the response should be rounded to the nearest whole number. The response should also be in English.

        Location: \(city)

        Planned Exercise: Outdoor running

        Weather Forecast Data:
        \(getFlatForecast(with: forecasts))
        """
        //print(finalPrompt)
        
        return finalPrompt
        
    }
    
    //create a prompt based on nutritional requirements
    func promptNutrition(weather forecasts: [ChartForecast], location: CLLocationCoordinate2D, city: String, intensity: String, duration: String) -> String {
        
        /*
         No gels should be recommended for runs 60 minutes or less. No fluids are needed during runs of 30 minutes or less. Provide recommendations for water and electrolytes when temperature is above 70 degrees, when humidity is above 70 percent, or when running for more than 30 minutes. The general tone of the response should be upbeat, positive and encouraging. When required, only refer to yourself in first person. Do not use any titles or sub headings in the response. Any numerical values provided in the response should be rounded to the nearest whole number. The response should also be in English. Ensure all sentences in your response have correct punctuation, spelling and grammar.

         */
        
        let finalPrompt = """
        User: I am planning a \(intensity.lowercased()) intensity run today for \(duration) in \(city). Based on the weather forecast, temperature, location altitude and humidity, provide nutritional advice on fueling with gels or electrolytes during my run. How many gels should I consume and at what interval? Also provide pre and post-run fueling advice. The response should provide a single 30 to 40 word paragraph. Assume I'll be starting my run sometime between the hours sunrise and sunset. No fluids are needed during runs of 30 minutes or less. Provide recommendations for water and electrolytes when temperature is above 70 degrees, when humidity is above 70 percent, or when running for more than 30 minutes. Provide an analysis of how you are using the weather to provide recommendations. Do not provide any recommendations as to the best time of day to run. The general tone of the response should be upbeat, positive and encouraging. When required, only refer to yourself in first person. Do not use any titles or sub headings in the response. Do not provide any recommendations for the best time to run during the day. Numerical values provided in the response should be rounded to the nearest whole number. The response should also be in English.

        Location: \(city), (coordinates: \(location.latitude), \(location.longitude))

        Planned Exercise: Outdoor running

        Weather Forecast Data:
        \(getFlatForecast(with: forecasts))
        """

        print(finalPrompt)

        return finalPrompt
    }
    
    
    //MARK: Helper functions
    
    func getCurrentTimezoneAsString() -> String {
        let timezone = TimeZone.current
        let identifier = timezone.identifier
        let abbreviation = timezone.abbreviation() ?? "Unknown"
        
        return "Timezone: \(identifier)\nAbbreviation: \(abbreviation)"
    }
    
    
    //provide the hourly weather forecast in a flatten string for AI analysis.
    private func getFlatForecast(with forecasts: [ChartForecast]) -> String {
        
        var results: String = ""
        let degreeSymbol: Character = "\u{00B0}"
        let bulletSymbol: Character = "\u{2981}"
        
        for forecast in forecasts {
            
            // Convert a UTC date string to a Date object
            if let utcDate = Date.fromUTCString(forecast.date.description) {
                
                //convert to local timezone.
                let localDateString = utcDate.toString()
                
                //print("Local time: \(localDateString)")
                results += "\(bulletSymbol) \(localDateString): Temperature: \(forecast.temp) \(degreeSymbol)F, Chance of Precipitation: \(forecast.pop * 100)%, Humidity: \(forecast.humidity)%."
            }
        }
        
        return results
    }
        
}

//MARK: these are just sample prompts to be used for testing..

extension String {
    
    static let promptParkrunSample: String = "I will be running 3.1 mile threshold effort at Perrigo Park in Redmond WA this coming Staturday at 9AM. It will be 45 degrees and cooler temperatures for this time of year with the possibility of rain showers sometime during the event. The altitude will be approximatley close to sea level. Provide a single 75-100 word essay for a suggested strategy. Use two paragraphs if needed. Include some common strategies for running 5K events. Include clothing and hydration advice. The general tone of the response should be upbeat, positive and encouraging."
    
    static let prompt10MileSample: String = "I took two gels on a 7 mile long last week and it was 70 degrees at sea level. Should I do the same thing this Saturday or change my strategy? It will be 65 degrees and sunny. I will also be doing 10 miles at 2500 feet. This will be training effort only and I will not be racing. Provide a single 50-75 word paragraph for a suggested strategy. Use two paragraphs if needed. The general tone of the response should be upbeat, positive and encouraging."
    
    static let promptNewRunner: String = "How do I train for a marathon? Provide a single 75-100 word essay for a suggested strategy. Use two paragraphs if needed. The general tone of the response should be upbeat, positive and encouraging. Be sure not to use any titles or sub headings in the response."
    
    static let promptTrailRace: String = "I have a 6.2 mile trail race this weekend and the course has 800 feet of vertical and will be around 2K above sea level in Marin Headlands. I currnetly run around 25 per week and aim to do around 800 of vertical per week. Provide nutrition suggestions before, during and after the event. Also clothing suggestions for the race. Provide a single 75-150 word paragraph for a suggested strategy. Use two or three paragraphs if needed. The general tone of the response should be upbeat, positive and encouraging. Be sure not to use any titles or sub headings in the response. The response should also be in English."
    
    static let promptWeatherAnalysis = "I am planning to run 3.1 miles Thursday, June 6 at the geographic coordinates of latitude 47.64373 and longitude -122.17364. The overall forecast calls for Clouds. High of 74° and low of 46°. Wind gusts up to 7 mph. Chance of precipitation is 0.0%. Based on the geographic region and anticipated weather forecast provide a time range for the suggested workout. This is a requirement. if the geographic location or temperature conditions look unfavorable for running, suggest the use of an indoor gym or treadmill. The response should be provide a single 50-75 word paragraph. Do not include the longitude and latitude coordinates in the response. Also, assume I want to start the run during daylight hours. The general tone of the response should be upbeat, positive and encouraging. Be sure not to use any titles or sub headings in the response. The response should also be in English."
    
}
