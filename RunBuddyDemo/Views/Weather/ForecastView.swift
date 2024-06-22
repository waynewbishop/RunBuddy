//
//  WeatherTest.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/29/24.
//

import SwiftUI
import CoreLocation
import Charts


//used for preview testing
extension CLLocationCoordinate2D {
    static let gigHarbor = CLLocationCoordinate2D(latitude: 47.64373, longitude: -122.17364)
    static let zionPark = CLLocationCoordinate2D(latitude: 37.1047193, longitude: -113.7286516)
}


struct ForecastView: View {
    
    @ObservedObject var engine = BuddyEngine()
    @StateObject var weatherEngine = WeatherEngine()
    
    @State var chartForecasts = [ChartForecast]()
    @State var location: CLLocationCoordinate2D
    @State var targetDate = ""
    @State var name = ""
    @State var duration = ""
    @State var terrain = ""
    @State var country = ""
    
    let degreeSymbol: Character = "\u{00B0}"
    
    //access key from plist.
    private let apiKey: String? = BuddyConfig.geminiApiKey

    //present date in long string format
    var headingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: targetDate) else {
            return "Invalid Date"
        }
        
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    //present date in true date format
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: targetDate) else {
            return nil
        }
        
        return date
    }

    
    var body: some View {
               
        VStack {
             VStack {
                Text(self.name)
                     .font(.title)
            }
            .frame(height: 100) // set the desired VStack height
            
            VStack {
                if engine.chunkResponse != "" {
                    VStack {
                        HStack {
                            Text("Weather Analysis")
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text(engine.chunkResponse)
                                .lineLimit(nil)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
            
            VStack {
                if engine.chunkResponse != "" {
                    HStack {
                        Text("\(weatherEngine.high.roundedNearest.description)\(degreeSymbol)")
                            .font(.title)
                        Text("\(weatherEngine.low.roundedNearest.description)\(degreeSymbol)")
                            .font(.title)
                            .foregroundColor(.gray)
                        weatherEngine.icon
                             .font(.system(size: 35, weight: .regular))
                            .symbolRenderingMode(.multicolor)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.blue.opacity(0.1))
                            )
                        Spacer()
                        //move presentation to the left
                    }
                    HStack {
                        Text("Fahrenheit (\(degreeSymbol)F)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                }
            }
            .padding(.horizontal)
            
            VStack {
                Chart {
                    ForEach(chartForecasts) { forecast in
                        LineMark (
                            x: .value("Hour", forecast.date, unit: .hour),
                            y: .value("Temp", forecast.temp)
                        )
                        .foregroundStyle(Color.blue.opacity(0.4))
                        
                        PointMark(
                            x: .value("Hour", forecast.date, unit: .hour),
                            y: .value("Temp", forecast.temp)
                        )
                        .foregroundStyle(Color.blue)
                        
                        AreaMark(
                            x: .value("Hour", forecast.date, unit: .hour),
                            y: .value("Humdity", forecast.humidity)
                        )
                        .foregroundStyle(Color.green.opacity(0.2))
                    }
                }
               .frame(height: 225)
                .padding()
                .chartYAxisLabel("Temperature / Humidity")
                
            }
            .onAppear() {
                self.weatherForecastData()
            }
        }
        
        //provide a bar chart for precipitation
        VStack {
            Chart {
                ForEach(chartForecasts) { forecast in
                    BarMark(
                        x: .value("Hour", forecast.date, unit: .hour),
                        y: .value("Percent Precipitation", forecast.pop * 100)
                    )
                    .foregroundStyle(Color.orange.opacity(0.4))
                }
            }
        }
        .frame(height: 150)
        .padding()
        .chartYAxisLabel("Percent Precipitation")
        
        Spacer()
    }
    
    
    //invoke engine and receive response.
    private func askRunBuddyAndGetResponse(_ prompt: String) {
        
        Task {
            do {
                try await engine.getGenerativeTextChunkAnswer(prompt: prompt, apiKey: apiKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func weatherForecastData() {
        
        Task {
            do {
                let forecastResponse = try await weatherEngine.fetchFiveDayForecast(for: location)
                
                //TODO: Add support for sunrise and sunset times in weather analysis prompt.
                //let sunrise = forecastResponse.city.sunrise
                
                //check the location name
                let city = forecastResponse.city.name
                if self.name == "" {
                    self.name = city
                    self.country = forecastResponse.city.country
                }
                
                //process collection on the main thread
                DispatchQueue.main.async {
                   let targetForecasts = weatherEngine.filterHourlyForecasts(forecastResponse, targetDate: targetDate)
                    
                    if let forecasts = targetForecasts {
                        //print(forecasts)
                        
                        weatherEngine.createWeatherSummary(with: forecasts)
                         
                        //iterate through results
                        for forecast in forecasts {
                            let item = ChartForecast(dt: forecast.dt, temp: forecast.main.temp, feels_like: forecast.main.feels_like, temp_min: forecast.main.temp_min, temp_max: forecast.main.temp_max, humidity: forecast.main.humidity, pop: forecast.pop)
                            
                            chartForecasts.append(item)
                           //print(item)
                        }
                    }
                    
                    //check forecast range.
                    if let chosenDate = date {
                        if chosenDate.isWithinFiveDays(of: Date()) {
                            
                            //build a new prompt for weather analysis
                            let prompt = Prompt()
                            let revisedPrompt = prompt.weatherAnalysisPrompt(with: chartForecasts, name: name, targetDate: targetDate)
                                                
                            self.askRunBuddyAndGetResponse(revisedPrompt)
                        }
                    }
                    
                    
                }
                
            } catch {
                print("Error: \(error)")
            }
        } //end task
    }    
}

#Preview {

    //provide test data..
    @State var targetDate = "2024-06-18"
    
    return VStack {
        ForecastView(location: .zionPark, targetDate: targetDate, name:"Zion National Park", duration: "30 minutes")
    }
}
