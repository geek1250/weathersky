//
//  Config.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-20.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//



import Foundation

struct Defaults {
    
    static let Latitude: Double = 37.8267
    static let Longitude: Double = -122.4233
    
}

struct API {
    
    static let APIKey = "d82e18a986cc378d9ae78b65623fa7f9"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
    
}
