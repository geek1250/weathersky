//
//  PlaceViewControllor.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-20.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit


var placeItems:[WeatherData] = [] {
    didSet {
        print("arrayChanged")
        //fetch new Place Weatehr
    }
}

class MainPlaceViewControllor: UITableViewController {
    
    fileprivate lazy var weatherDataManager = {
        return WeatherDataManager(baseURL: API.AuthenticatedBaseURL)
    }()
    
    fileprivate lazy var localStoreManager = {
        return LocalStoreManager()
    }()
    
    var weatherData: WeatherData?
    
    
    var addButton = UIButton()
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Weather Sky"
        
        if placeItems.count > 0 {
            fetchWeatherData(weatherData: placeItems.last!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.red, for: .normal)
        addButton.setImage(UIImage(named:"add"), for: .normal)
        addButton.frame = CGRect(x:self.view.frame.width - 60, y:self.view.frame.height - 94,width: 50, height:50)
        addButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        self.parent?.view.addSubview(addButton)
        
        getStoragePlaces()
        tableView.reloadData()
                 
        
    }
    
    func buttonTapped(_ button: UIButton!) {
        self.performSegue(withIdentifier: "addPlace", sender: self)
    }
    
    func getStoragePlaces() {
        let storedWeatherData = localStoreManager.getWeatherDatas()
        parseStoredWeatherData(storedWeatherData: storedWeatherData)
        
    }
    
    func parseStoredWeatherData(storedWeatherData : [[String: Any]]?) {
        if let loadedCart = storedWeatherData {
            print(loadedCart)  
            for item in loadedCart {
                var weather : WeatherData = WeatherData()
                let name = item["name"]  as! String
                let temperature = item["temperature"] as! Double
                weather.name = name
                weather.temperature = temperature
                if let dailyData = item["dailyData"] as? [[String: Any]] {
                    for daily in dailyData {
                        if daily.count > 0 {
                            var dailyWeather = WeatherDayData()
                            let dailyTemperatureMax = daily["temperatureMax"] as! Double
                            let dailyTemperatureMin = daily["temperatureMin"] as! Double
                            let windSpeed = daily["windSpeed"] as! Double
                            let precipProbability = daily["precipProbability"] as! Double
                            let dailytime = daily["time"]  as! Date
                            dailyWeather.temperatureMax = dailyTemperatureMax
                            dailyWeather.temperatureMin = dailyTemperatureMin
                            dailyWeather.windSpeed = windSpeed
                            dailyWeather.precipProbability = precipProbability
                            dailyWeather.time = dailytime
                            weather.dailyData.append(dailyWeather)
                        }
                    }//for
                }//if
                placeItems.append(weather)
            }//for
        }//if
    }
    
    fileprivate func fetchWeatherData(weatherData:WeatherData) {
        // guard let location = currentLocation else { return }
        
        let latitude = weatherData.lat
        let longitude = weatherData.long
        
        print("\(latitude), \(longitude)")
        
        
        weatherDataManager.weatherDataForLocation(latitude: latitude, longitude: longitude) { (response, error) in
            if let error = error {
                print(error)
            } else if let response = response {
                // Configure Day View Controller
                //self.now = response
                let name = weatherData.name
                self.weatherData = response
                self.weatherData?.name = name
                // Configure Week View Controller
                self.weatherData?.dailyData = response.dailyData
                
                self.updateWeatherDataContainer(withWeatherData: self.weatherData!)
            }
        }
    }
    
    
    private func updateWeatherDataContainer(withWeatherData weatherData: WeatherData) {
        //weatherDataContainer.isHidden = false
        
        var windSpeed = weatherData.windSpeed
        var temperature = weatherData.temperature
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM d"
        //dateLabel.text = dateFormatter.string(from: weatherData.time)
        
        
        
        let sumary = weatherData.summary
        placeItems[placeItems.count - 1].temperature = temperature
        placeItems[placeItems.count - 1].dailyData = weatherData.dailyData
        
        localStoreManager.addWeatherData(weatherData: weatherData)
        tableView.reloadData()
    }

    
    
    //TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = placeItems[row].name
        
        let  temperature = String(format: "%.0f°", placeItems[row].temperature)//placeItems[row].temperature
        cell.detailTextLabel?.text = "\(temperature)"
        cell.detailTextLabel?.textColor = UIColor.red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localStoreManager.deleteWeatherData(placeName: placeItems[indexPath.row].name)
            placeItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        weatherData = placeItems[indexPath.row]
        self.performSegue(withIdentifier: "showWeatherDetails", sender: self)
        
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        navigationItem.title = nil
        if segue.identifier == "addPlace"{
            let vc = segue.destination as! AddPlaceViewController
            vc.navigationItem.title = "Weatehr Sky"
            //navigationItem.title = "dd"
        }
        if segue.identifier == "showWeatherDetails"{
            let navController = segue.destination as! UINavigationController
            let detailController = navController.topViewController as! WeatherDetailViewControllor
            detailController.weatherData = weatherData
            detailController.navigationItem.title = weatherData?.name //"Weatehr Sky"
        }
    }
    
   
}
