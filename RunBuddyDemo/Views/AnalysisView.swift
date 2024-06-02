//
//  AnalysisView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/24/24.
//

import SwiftUI
import CoreLocation

struct AnalysisView: View {
    
    @Binding var showModal: Bool
    
    @State var isAnimating: Bool = true
    @State var city = "Snohomish"
    @State var location = CLLocationCoordinate2D()
    @State var targetDate = Date()
        
    var body: some View {
        VStack {
            HStack {
                EllipsisView(isAnimating: $isAnimating)
                Spacer()
                Button(action: {
                    showModal = false
                }) {
                    Image(systemName: "xmark")
                      .resizable()
                      .frame(width: 16, height: 16)
                      .padding()
                }
            }
            .padding()
            
            ScrollView {
                VStack {
                    Text(city)
                        .font(.largeTitle)
                    
                    Text("Sunday, June 2")
                        .font(.subheadline)
                }
                
                VStack {
                    //insert swift chart statistics
                    //only if the target date is 5 days or less from the
                    //current date. If not show a some sort of custom view
                    //that explains how it works..
                    ForecastView()
                }
                Spacer() //keep everything top aligned..
                
            } //end scrollview
        }
    }
}



#Preview {

    @State var showModal: Bool  = false
    return VStack {
        AnalysisView(showModal: $showModal)
    }

}
