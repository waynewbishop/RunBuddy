//
//  NutritionView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 7/1/24.
//

import SwiftUI

struct NutritionView: View {
    
    @ObservedObject var engine = BuddyEngine()
    
    @State var chartForecasts: [ChartForecast]
    @State var question: Question
    @State var apiKey: String?
    
    var body: some View {
        VStack {
           // if engine.chunkResponse != "" {
                VStack {
                    HStack {
                        Text("Nutrition Analysis")
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
            //}
        }
        .onAppear() {
            self.getNutritionAnalysis()
        }
        .padding(.bottom)
    }
   

    //obtain the nutritional analysis
    private func getNutritionAnalysis() {
        //build out the prompt and pass it to the AI engine.
        
        //build a new prompt for weather analysis
        //let prompt = Prompt()
        //let revisedPrompt = prompt.weatherAnalysis(with: chartForecasts, name: name, targetDate: targetDate)
                
    }
    
}

#Preview {
        
    @State var selectedDate = Date().advanceDays(by: 0)
    @State var chartForecasts = [ChartForecast]()
    
    @State var previewQuestion = Question(name: "Gig Harbor", location: .gigHarbor, duration: "30 minutes", selectedDate: selectedDate.advanceDays(by: 1), selectedOption: "Easy", terrainOption: "Road", nutrition: false, kit: false, hydration: false)

    var apiKey: String? = BuddyConfig.geminiApiKey
    

    return VStack {
        NutritionView(chartForecasts: chartForecasts, question: previewQuestion, apiKey: apiKey)
    }
    
}
