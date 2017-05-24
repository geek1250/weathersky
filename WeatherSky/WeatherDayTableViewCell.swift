//
//  WeatherDayTableViewCell.swift
//  WeatherSky
//
//  Created by Kevin Zhang on 2017-05-23.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import UIKit

class WeatherDayTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "WeatherDayCell"
    
    // MARK: - Properties
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure Cell
        selectionStyle = .none
    }
    
}
