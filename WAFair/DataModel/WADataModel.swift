//
//  WADataModel.swift
//  WAFair
//
//  Created by Shudhanshu on 12/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import Foundation

public struct WeatherResponse : Codable{
    public let cod : String
    public let message : Int
    public let city : WeatherCity
    public let cnt : Int
    public let list : [WeatherData]
}

public struct WeatherCity : Codable {
    public let id : Double
    public let name : String
    public let coord : CityCoordinate
    public let country : String
    public let timezone : Double
    public let sunrise : Double
    public let sunset : Double
}

public struct CityCoordinate : Codable {
    public let lat : Double
    public let lon : Double
}

public struct WeatherData : Codable{
    public let dt : Double
    public let main : WeatherMain
    public let weather : [Weather]
    public let clouds : Clouds
    public let wind : Wind
    public let dt_txt : String
}

public struct WeatherMain : Codable{
    public let temp : Double
    public let feels_like : Double
    public let temp_min : Double
    public let temp_max : Double
    public let pressure : Int
    public let sea_level : Int
    public let grnd_level : Int
    public let humidity : Int
    public let temp_kf : Double
}

public struct Weather : Codable{
    public let id : Int
    public let main : String
    public let description : String
    public let icon : String
}

public struct Clouds : Codable{
    public let all : Int
}

public struct Wind : Codable{
    public let speed : Double
    public let deg : Double
}



