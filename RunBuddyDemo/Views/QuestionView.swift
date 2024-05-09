//
//  ContentView2.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/19/24.
//

import Foundation

import SwiftUI
import GoogleGenerativeAI

struct QuestionView: View {
    
@ObservedObject var engine = BuddyEngine()
@State var isAnimating: Bool = false
    
private let apiKey: String? = "AIzaSyBjMts2i3xOTtfATk7ZfUBshUUlv6QQuDU"

    var body: some View {
        HStack {
            VStack {
                HStack {
                    EllipsisView(isGenerating: $isAnimating)
                    
                    Button("Ask RunBuddy..") {
                        //intiate thinking animation
                        isAnimating = true
                       
                        Task {
                          do {
                              try await engine.getGenerativeTextChunkAnswer(prompt: .prompt10MileSample, apiKey: apiKey)
                              
                          } catch {
                            print(error.localizedDescription)
                            isAnimating = false
                          }
                        }
                    }
                 .padding(5)
                } //end hstack
                
                TextField("Waiting for an answer..", text: $engine.chunkResponse, axis: .vertical)
                    .frame(minHeight: 20) // Sets a minimum height to prevent collapse
                    .padding(15)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.primary)
                    .onChange(of: engine.chunkResponse) { oldValue, newValue in
                        isAnimating = false
                    }
            }
 
        }
        .padding()
    }
}


#Preview {
    QuestionView()
}
