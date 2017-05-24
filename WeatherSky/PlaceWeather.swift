//
//  PlaceWeather.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-20.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import Foundation

//struct PlaceWeather {
struct PlaceWeather {
    
    let name = ""
    var WeatherData: WeatherData
    
}

struct WeatherData {
    var name = ""
    
    var time: Date
    
    var lat: Double
    var long: Double
    var windSpeed: Double
    var temperature: Double
    
    var icon: String
    var summary: String
    
    var dailyData: [WeatherDayData]
    
    init() {
        self.lat = 0.0
        self.long = 0.0
        self.dailyData = []
        
        self.icon = ""
        self.summary = ""
        self.windSpeed = 0.0
        self.temperature = 0.0
        
        let time: Double = 0.0
        self.time = Date(timeIntervalSince1970: time)
    }
    
}

extension WeatherData: JSONDecodable {
    
    init(decoder: JSONDecoder) throws {
        self.lat = try decoder.decode(key: "latitude")
        self.long = try decoder.decode(key: "longitude")
        self.dailyData = try decoder.decode(key: "daily.data")
        
        self.icon = try decoder.decode(key: "currently.icon")
        self.summary = try decoder.decode(key: "currently.summary")
        self.windSpeed = try decoder.decode(key: "currently.windSpeed")
        self.temperature = try decoder.decode(key: "currently.temperature")
        
        let time: Double = try decoder.decode(key: "currently.time")
        self.time = Date(timeIntervalSince1970: time)
    }
    
}
