//
//  BuddyConfig.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/9/24.
//

import Foundation

enum BuddyConfigError: Error {
    case failedToLoadAPIKey
}

/// Process to load the apiKey from the plist.
/// Note: End users will need to create their own personalized
/// BuddyConfig.plist as this does not get pushed to Github.
struct BuddyConfig {
    
    static let geminiApiKey: String = {
        do {
            guard let filePath = Bundle.main.path(forResource: "BuddyConfig", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: filePath),
                  let apiKey = plist["GeminiAPIKey"] as? String else {
                throw BuddyConfigError.failedToLoadAPIKey
            }
            return apiKey
        } catch {
            // Handle the error gracefully
            print("Error loading API key: \(error)")
            return "DefaultAPIKey"
        }
    }()

    
    static let openWeatherApiKey: String = {
        do {
            guard let filePath = Bundle.main.path(forResource: "BuddyConfig", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: filePath),
                  let apiKey = plist["OpenWeatherAPIKey"] as? String else {
                throw BuddyConfigError.failedToLoadAPIKey
            }
            return apiKey
        } catch {
            // Handle the error gracefully
            print("Error loading API key: \(error)")
            return "DefaultAPIKey"
        }
    }()
    
}
