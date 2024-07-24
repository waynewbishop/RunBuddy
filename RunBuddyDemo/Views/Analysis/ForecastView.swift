//
//  WeatherTest.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/29/24.
//

import SwiftUI
import CoreLocation
import MapKit
import Charts


//used for preview testing
extension CLLocationCoordinate2D {
    static let gigHarbor = CLLocationCoordinate2D(latitude: 47.64373, longitude: -122.17364)
    static let zionPark = CLLocationCoordinate2D(latitude: 37.1047193, longitude: -113.7286516)
}


struct ForecastView: View {
            
    @StateObject var engine = BuddyEngine()
    @StateObject var weatherEngine = WeatherEngine()
    
    @Binding var chartForecasts: [ChartForecast]
    
    @State var location: CLLocationCoordinate2D
    @State var targetDate = ""
    @State var name = ""
    @State var duration = ""
    @State var apiKey: String?
        
    let degreeSymbol: Character = "\u{00B0}"
    
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
                
            }
            .frame(height: 20)
             VStack {
                Text(self.name)
                     .font(.title)
                 Text(headingDate)
                     .font(.subheadline)
                     .foregroundStyle(.gray.opacity(0.6))
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
                        .foregroundStyle(Color.blue.opacity(0.2))
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Hour", forecast.date, unit: .hour),
                            y: .value("Temp", forecast.temp)
                        )
                        .foregroundStyle(Color.blue.opacity(0.6))
                        
                        AreaMark(
                            x: .value("Hour", forecast.date, unit: .hour),
                            y: .value("Humidity", forecast.humidity)
                        )
                        .interpolationMethod(.catmullRom) // Add this line
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .green]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .opacity(0.2)
                        )
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
        .padding(.horizontal)
        .chartYAxisLabel("Percent Precipitation")
        
        if chartForecasts.count > 0 {
            HStack {
                Text("Data is based on forecasted local weather. Accuracy is not guaranteed.")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
                Spacer()
            }
            .padding()
        }
        Spacer()
    }
    
    
    //invoke engine and receive response.
    private func getForecastAnalysis(_ prompt: String) {
        
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
                                
                //check location name
                let city = forecastResponse.city.name
                
                if self.name == "" {
                    self.name = city
                }
                
                //process collection on the main thread
                DispatchQueue.main.async {
                   let targetForecasts = weatherEngine.filterHourlyForecasts(forecastResponse, targetDate: targetDate)
                    
                    if let forecasts = targetForecasts {
                        weatherEngine.createWeatherSummary(with: forecasts)
                         
                        //iterate through results
                        for forecast in forecasts {
                            let item = ChartForecast(dt: forecast.dt, temp: forecast.main.temp, feels_like: forecast.main.feels_like, temp_min: forecast.main.temp_min, temp_max: forecast.main.temp_max, humidity: forecast.main.humidity, pop: forecast.pop)
                            
                            chartForecasts.append(item)
                        }
                    }
                    
                    //check forecast range.
                    if let chosenDate = date {
                        if chosenDate.isWithinFiveDays(of: Date()) {
                            
                            //build a new prompt for weather analysis
                            let prompt = Prompt()
                            let weatherPrompt = prompt.promptForecast(weather: chartForecasts, city: name, targetDate: targetDate)
                                                
                            self.getForecastAnalysis(weatherPrompt)
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
    @State var targetDate = "2024-07-23"
    @State var chartForecasts = [ChartForecast]()    
    @State var selectedDate = Date().advanceDays(by: 0)
    @State var apiKey: String? = BuddyConfig.geminiApiKey
    
    @State var testQuestion = Question(city: "Gig Harbor", location: .gigHarbor, duration: "30 minutes", selectedDate: selectedDate.advanceDays(by: 1), intensity: "Easy", terrainOption: "Road", nutrition: false, kit: false)
    
    return VStack {
        ForecastView(chartForecasts: $chartForecasts, location: .gigHarbor, targetDate: targetDate, name:"Zion National Park", duration: "30 minutes", apiKey: apiKey)
    }
    
}
