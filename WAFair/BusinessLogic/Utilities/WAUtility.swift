//
//  WAUtility.swift
//  WAFair
//
//  Created by Shudhanshu on 13/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import Foundation
import UIKit

class WAUtility : NSObject {
    
    static let sharedInstance = WAUtility()
    private override init() {}
    
    func dateFormatter(_ format : String) -> DateFormatter{
        let dateForamtter = DateFormatter()
        dateForamtter.dateFormat = format
        dateForamtter.timeZone = TimeZone.current
        return dateForamtter
    }
    
    func getTime(_ time : Double) -> String{
        let dateFormatter = self.dateFormatter("H:mm a")
        return dateFormatter.string(from: Date(timeIntervalSince1970: time))
    }
    
    func getTodayDate() -> String{
        let df = self.dateFormatter("yyyy-MM-dd")
        return df.string(from: Date())
    }
    
    func getSelectedWeatherData(_ date : Date , object : WeatherResponse) -> [WeatherData]{
        let df = self.dateFormatter("yyyy-MM-dd")
        let selectedDate = df.string(from: date)
        let weatherObject = object.list.filter {$0.dt_txt.contains(selectedDate)}
        return weatherObject
    }
    
    func getFirstSegmentData(objects : [WeatherData]) -> (X : [Int] , YFirst : [Double] , YSecond : [Double]){
        let hours = objects.map {Calendar.current.component(.hour, from: Date(timeIntervalSince1970: $0.dt))}
        let temp_min = objects.map{ Double(convertTemp($0.main.temp_min).replacingOccurrences(of: "°C", with: ""))!}
        let temp_max = objects.map{ Double(convertTemp($0.main.temp_max).replacingOccurrences(of: "°C", with: ""))!}
        return (hours,temp_min,temp_max)
    }
    
    func getSecondSegmentData(objects : [WeatherData]) -> (X : [Int] , YFirst : [Double]){
        let hours = objects.map {Calendar.current.component(.hour, from: Date(timeIntervalSince1970: $0.dt))}
        let wind = objects.map {$0.wind.speed}
        return (hours,wind)
    }
    
    func getThirdSegmentData(objects : [WeatherData]) -> (X : [Int] , YFirst : [Double]){
        let hours = objects.map {Calendar.current.component(.hour, from: Date(timeIntervalSince1970: $0.dt))}
        let humidity = objects.map {Double($0.main.humidity)}
        return (hours,humidity)
    }
    
    func getTodaysTempertaure(_ object : WeatherData) -> (String,String,String) {
        return (self.convertTemp(object.main.temp),object.weather[0].icon,object.weather[0].description)
    }
    
    func convertTemp(_ tempertaure : Double) -> String{
        let mf = MeasurementFormatter()
        mf.locale = Locale(identifier: "en_GB")
        mf.numberFormatter.maximumFractionDigits = 2
        let input = Measurement(value: tempertaure, unit: UnitTemperature.kelvin)
        let output = input.converted(to: .celsius)
        return mf.string(from: output)
    }
    
}
