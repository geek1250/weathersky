//
//  UserDefault+extension.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-20.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import Foundation



final class LocalStoreManager {
    func addWeatherData(weatherData : WeatherData) {
        
        var dailyData : [ [String: Any] ] = [[:]]
        //var myDictionary = Dictionary<String, Any>()
        for each in weatherData.dailyData
        {
            let weatherDataDict = ["temperatureMax" :each.temperatureMax,
                                   "temperatureMin" :each.temperatureMin,
                                   "windSpeed" :each.windSpeed,
                                   "precipProbability" :each.precipProbability,
                                   "time":each.time
                               ] as [String : Any]
            dailyData.append(weatherDataDict)
        }
        
        var weatherDatas = getWeatherDatas()
        let current = ["name" : weatherData.name,
                 "temperature" : weatherData.temperature,
                 "dailyData" : dailyData
        ] as [String : Any]
        
        if weatherDatas.count == 0 {
            weatherDatas.append(current)
        }else{
            var exist = false
            for i in 0..<weatherDatas.count {
                let name = weatherDatas[i]["name"]  as! String
                if name == weatherData.name{
                    exist = true
                    weatherDatas[i] = current
                    
                }
            }
            if exist == false {
                weatherDatas.append(current)
            }
        }
        
//        let weatherDatas = [
//            ["name" : weatherData.name,
//             "temperature" : weatherData.temperature,
//             "dailyData" : dailyData
//            ]
//        ]
       
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: weatherDatas)
        
  
        UserDefaults.standard.set(weatherDatas, forKey: "weatherDatas")
        
        
    }
    func deleteWeatherData(placeName : String) {
        var weatherDatas = getWeatherDatas()
        if weatherDatas.count > 0 {
            var deleteId = -1
            for i in 0..<weatherDatas.count {
                let name = weatherDatas[i]["name"]  as! String
                if name == placeName {
                    deleteId = i
                }
            }
            if deleteId >= 0 {
                weatherDatas.remove(at: deleteId)
            }
        }
        UserDefaults.standard.set(weatherDatas, forKey: "weatherDatas")
    }
    func getWeatherDatas() -> [[String: Any]] {
        if let loadedCart = UserDefaults.standard.array(forKey: "weatherDatas") as? [[String: Any]] {
            print(loadedCart)  // [[price: 19.99, qty: 1, name: A], [price: 4.99, qty: 2, name: B]]"
//            for item in loadedCart {
//                print(item["name"]  as! String)
//                print(item["temperature"] as! Double)
//                if let dailyData = item["dailyData"] as? [[String: Any]] {
//                    for daily in dailyData {
//                        if daily.count > 0 {
//                            print(daily["temperatureMax"] as! Double)
//                            print(daily["time"]  as! Date)
//                        }
//                        
//                        
//                    }//for
//                }//if
//            }//for
            return loadedCart
        }//if
        return []
    }
    
}
