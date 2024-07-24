//
//  AnalysisView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/24/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnalysisView: View {
    @Binding var showModal: Bool
    
    @State var question: Question
    @State var chartForecasts = [ChartForecast]()
   
    @State private var refreshTrigger = false
    @State private var isSharePresented = false
    @State private var isConfirmationPresented = false
    
    private let apiKey: String? = BuddyConfig.geminiApiKey
    
    var targetDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: question.selectedDate)
    }
    
    
    var body: some View {
        ScrollView {
            VStack {                
                HStack {
                    Spacer()
                }
                .padding()
                HStack {
                    Button(action: {
                        showModal = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(6)
                    Spacer()
                    Button(action: {
                               // Show confirmation dialog
                               isConfirmationPresented = true
                           }) {
                               Image(systemName: "ellipsis")
                                   .font(.title2)
                           }
                           .confirmationDialog("Choose an action", isPresented: $isConfirmationPresented) {
                               Button("Refresh Results") {
                                   refreshView()
                               }
                               
                               Button("Share") {
                                   // Call sheet to invoke sharing options
                                   isSharePresented = true
                               }
                               
                               Button("Cancel", role: .cancel) {}
                           }
                           .sheet(isPresented: $isSharePresented, content: {
                               ActivityView(activityItems: [
                                   "Gig Harbor, July 7th.",
                                   "Greate news! This morning the temperature and humidity will be ideal for a run."
                               ])
                           })

                }
                .padding(.horizontal)
                
                VStack {
                    //show weather and supporting analysis
                    ForecastView(chartForecasts: $chartForecasts, location: question.location, targetDate: targetDate, name: question.city, duration: question.duration, apiKey: apiKey)
                }
                
                VStack {
                   NutritionView(chartForecasts: $chartForecasts, question: question, apiKey: apiKey)
                }
                
            }
            .id(refreshTrigger)
        }
    }
    
    // toggle the refresh trigger
    private func refreshView() {
        chartForecasts.removeAll() //needs to be reset manually since the data persists
        refreshTrigger.toggle()
    }
    
}



#Preview {
    @State var showModal: Bool  = false
    @State var selectedDate = Date().advanceDays(by: 0)
    
    @State var testQuestion = Question(city: "Gig Harbor", location: .gigHarbor, duration: "30 minutes", selectedDate: selectedDate.advanceDays(by: 1), intensity: "Easy", terrainOption: "Road", nutrition: false, kit: false, hydration: false)
    
    return VStack {
        AnalysisView(showModal: $showModal, question: testQuestion)
    }

}
