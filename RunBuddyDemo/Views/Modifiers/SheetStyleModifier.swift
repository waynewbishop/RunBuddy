//
//  SheetStyle.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/30/24.
//

import SwiftUI
import MapKit

struct SheetStyleModifier: ViewModifier {

  func body(content: Content) -> some View {
    content
      .padding()
      .interactiveDismissDisabled()
      .presentationDetents([.height(350), .large])
      .presentationBackground(.thickMaterial)
      .presentationBackgroundInteraction(.enabled(upThrough: .large))
  }
}

//the applied name of the modifier
extension View {
  func buddySheetStyle() -> some View {
      modifier(SheetStyleModifier())
  }
}


#Preview {
    @State var isSheetPresented: Bool = true
    return VStack {
        Text("MapView goes here..")
    }
    .sheet(isPresented: $isSheetPresented) {
        //some sample view can go here..
    }
}

