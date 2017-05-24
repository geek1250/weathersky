//
//  WeatherDetailViewControlloer2.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-23.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import UIKit

class WeatherDetailViewControllor: UIViewController {
    var weatherData: WeatherData?
    //var tableView: UITableView?
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "dayWeatherCell"
    
    
    //Date
    fileprivate lazy var dayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView?.register(WeatherDayTableViewCell.self, forCellReuseIdentifier:cellIdentifier )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
    }
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}


extension WeatherDetailViewControllor: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherData == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData == nil ? 0 : 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableViewCell.reuseIdentifier, for: indexPath) as? WeatherDayTableViewCell else { fatalError("Unexpected Table View Cell") }
        
        let row = indexPath.row
        
        let windSpeed = weatherData?.dailyData[row].windSpeed
        let temperatureMin = weatherData?.dailyData[row].temperatureMin
        let temperatureMax = weatherData?.dailyData[row].temperatureMax
        let precipProbability = weatherData?.dailyData[row].precipProbability
        
        let day = dayFormatter.string(from: (weatherData?.dailyData[row].time)!)
        let date = dateFormatter.string(from: (weatherData?.dailyData[row].time)!)
        
        cell.dayLabel.text = day
        cell.dateLabel.text = date
        
        let min = String(format: "%.0f°", temperatureMin!)
        let max = String(format: "%.0f°", temperatureMax!)
        let average = String(format: "%.0f°", (temperatureMax! + temperatureMin!)/2)
        cell.temperatureLabel.text = "\(average)(A) \(min)(L) \(max)(H)"
        
        cell.chanceOfRainLabel.text = String(format: "%.2f", precipProbability!)
        
        cell.windSpeedLabel.text = String(format: "%.2f", windSpeed!)
        
        cell.iconImageView.image = imageForIcon(withName: (weatherData?.dailyData[row].icon)!)
        
        return cell
    }
    
    func imageForIcon(withName name: String) -> UIImage? {
        switch name {
        case "clear-day":
            return UIImage(named: "clear-day")
        case "clear-night":
            return UIImage(named: "clear-night")
        case "rain":
            return UIImage(named: "rain")
        case "snow":
            return UIImage(named: "snow")
        case "sleet":
            return UIImage(named: "sleet")
        case "wind", "cloudy", "partly-cloudy-day", "partly-cloudy-night":
            return UIImage(named: "cloudy")
        default:
            return UIImage(named: "clear-day")
        }
    }
}
