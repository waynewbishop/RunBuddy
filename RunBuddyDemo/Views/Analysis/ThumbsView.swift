//
//  ThumbsView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/8/24.
//

import SwiftUI

struct ThumbsView: View {
    
    
    var body: some View {
            GroupBox {
                HStack {
                    Text("Double-check responses.")
                        .font(.caption)
                    HStack(spacing: 20) {
                        Button(action: {
                            // Handle thumbs up action
                        }) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.subheadline)
                        }
                        
                        Button(action: {
                            // Handle thumbs down action
                        }) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .font(.subheadline)
                        }
                        
                        Button(action: {
                            // Handle save action
                        }) {
                            Image(systemName: "repeat.circle.fill")
                                .font(.subheadline)
                        }
                        
                        Button(action: {
                            // Handle save action
                        }) {
                            Image(systemName: "square.and.arrow.down.fill")
                                .font(.subheadline)
                        }
                    }
                }

            }
            .padding()
            .frame(maxWidth: .infinity)
        }
}

#Preview {
    ThumbsView()
}
