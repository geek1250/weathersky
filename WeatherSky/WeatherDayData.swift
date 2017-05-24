//
//  WeatherDayData.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-20.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import Foundation

struct WeatherDayData {
    
    var time: Date
    var icon: String
    var windSpeed: Double
    var temperatureMin: Double
    var temperatureMax: Double
    var precipProbability: Double ////chance of rain
    
    init() {
        
        self.icon = ""
        self.windSpeed = 0.0
        self.temperatureMin = 0.0
        self.temperatureMax = 0.0
        self.precipProbability = 0.0
        let time: Double = 0.0
        self.time = Date(timeIntervalSince1970: time)
    }
    
    
}

extension WeatherDayData: JSONDecodable {
    
    init(decoder: JSONDecoder) throws {
        self.icon = try decoder.decode(key: "icon")
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperatureMin = try decoder.decode(key: "temperatureMin")
        self.temperatureMax = try decoder.decode(key: "temperatureMax")
        
        self.precipProbability = try decoder.decode(key: "precipProbability")
        
        let time: Double = try decoder.decode(key: "time")
        self.time = Date(timeIntervalSince1970: time)
        
        //self.humidity = try decoder.decode(key: "humidity")

        
        
    }
    
}
