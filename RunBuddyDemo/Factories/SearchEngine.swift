//
//  SearchEngine.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/1/24.
//

import Foundation
import MapKit
import SwiftUI

struct SearchEngine {

    @Binding var searchResults: [MKMapItem]
    
    func search(for query: String, in searchRegion: MKCoordinateRegion) async throws -> () {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        //searchable region
        request.region = searchRegion
        
        let search = MKLocalSearch(request: request)
        
        do {
            let response = try await search.start()
            
            //update binding property on main thread
            DispatchQueue.main.async {
                self.searchResults = response.mapItems
                print("\(searchResults.count) search results..")
            }
          } catch {
            //throw a general error
            print("Error during search..")
            throw error
          }
        
    } //end function
    
    //associates a map point of interest with a system icon
    func getSymbolForCategory(_ category: MKPointOfInterestCategory) -> Image {
        switch category {
            case .airport:
                return Image(systemName: "airplane")
            case .amusementPark:
                return Image(systemName: "ferriswheel")
            case .aquarium:
                return Image(systemName: "fish")
            case .atm:
                return Image(systemName: "atm")
            case .bakery:
                return Image(systemName: "bread.slice")
            case .bank:
                return Image(systemName: "building.columns")
            case .beach:
                return Image(systemName: "beach.umbrella")
            case .brewery:
                return Image(systemName: "mug")
            case .cafe:
                return Image(systemName: "cup.and.saucer")
            case .campground:
                return Image(systemName: "tent")
            case .carRental:
                return Image(systemName: "car")
            case .evCharger:
                return Image(systemName: "bolt.car")
            case .fireStation:
                return Image(systemName: "truck.firefighter")
            case .fitnessCenter:
                return Image(systemName: "figure.walk")
            case .gasStation:
                return Image(systemName: "gas.pump")
            case .hospital:
                return Image(systemName: "hospital")
            case .hotel:
                return Image(systemName: "bed.double")
            case .laundry:
                return Image(systemName: "washer")
            case .library:
                return Image(systemName: "book")
            case .marina:
                return Image(systemName: "ship.ferry")
            case .movieTheater:
                return Image(systemName: "film")
            case .museum:
                return Image(systemName: "paintpalette")
            case .nationalPark:
                return Image(systemName: "tree")
            case .park:
                return Image(systemName: "leaf")
            case .parking:
                return Image(systemName: "parkingsign")
            case .pharmacy:
                return Image(systemName: "pill")
            case .police:
                return Image(systemName: "badge.sheriff")
            case .postOffice:
                return Image(systemName: "envelope")
            case .restaurant:
                return Image(systemName: "fork.knife")
            case .restroom:
                return Image(systemName: "toilet")
            case .school:
                return Image(systemName: "schoolhouse")
            case .stadium:
                return Image(systemName: "sportscourt")
            case .university:
                return Image(systemName: "graduationcap")
            case .winery:
                return Image(systemName: "winebottle")
            case .zoo:
                return Image(systemName: "paw")
            default:
                return Image(systemName: "mappin.and.ellipse")
        }
    }
}


