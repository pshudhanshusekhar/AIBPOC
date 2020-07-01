//
//  WANetworkCaller.swift
//  WAFair
//
//  Created by Shudhanshu on 12/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import Foundation

class WANetworkCaller {
    
    class func getData(_ latitude : Double , longitude : Double , completion: @escaping (Result<(URLResponse , Data) , Error>) -> Void){
        let finalURL = URL(string: "\(WeatherServiceAPI.NetworkAPI.baseURL.rawValue)lat=\(latitude)&lon=\(longitude)&appid=\(APIKeys.keys.weatherKey.rawValue)")!
        let task = URLSession.shared.dataTask(finalURL) { (result) in
            completion(result)
        }
        task.resume()
    }
    
    class func getICONData(_ text : String , completion: @escaping(Data?)-> Void){
        let finalURL = URL(string: "\(WeatherServiceAPI.NetworkAPI.iconURL.rawValue)\(text)@2x.png")!
        let task = URLSession.shared.dataTask(finalURL) { (result) in
            switch result{
            case .success(let(_ , data)):
                completion(data)
                break
            case .failure(_):
                completion(nil)
                break
            }
        }
        task.resume()
    }
}
