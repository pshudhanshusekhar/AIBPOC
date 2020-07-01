//
//  WAConstants.swift
//  WAFair
//
//  Created by Shudhanshu on 13/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import Foundation
import UIKit

let bFColor = UIColor.init(displayP3Red: 238/256, green: 205/256, blue: 163/256, alpha: 0.8)
let bSColor = UIColor.init(displayP3Red: 239/256, green: 98/256, blue: 159/256, alpha: 0.8)

let bCellFColor = UIColor.init(displayP3Red: 214/256, green: 109/256, blue: 117/256, alpha: 0.8)
let bCellSColor = UIColor.init(displayP3Red: 226/256, green: 149/256, blue: 135/256, alpha: 0.8)

class WeatherServiceAPI {
    
    public enum NetworkAPI : String {
        case baseURL = "https://api.openweathermap.org/data/2.5/forecast?"
        case iconURL = "https://openweathermap.org/img/wn/"
    }
        
    public enum APIServiceError : Error {
        case apiError
        case invalidPoint
        case invalidResponse
        case noData
        case decodeError
    }
}

class APIKeys {
    
    public enum keys : String {
        case weatherKey = "321a5b8220b7464216dd2716a0bb2b70"
        case placesKey = ""
    }
    
}

    
let sunrise = "\u{1F305}"
let sunset = "\u{1F307}"
