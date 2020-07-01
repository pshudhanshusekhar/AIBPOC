//
//  WALocationHandler.swift
//  WAFair
//
//  Created by Shudhanshu on 12/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import CoreLocation

protocol WALocationHandlerDelegate {
    func getCurrentLocation(coordinate : CLLocationCoordinate2D?)
}

class WALocationHandler : NSObject , CLLocationManagerDelegate {
    
    static let sharedInstance = WALocationHandler()
    private override init() {}
    
    var locationDelegate : WALocationHandlerDelegate?
    var locationManagaer : CLLocationManager!
    
    func registerLocation(){
        self.initializeLocation()
        locationManagaer.requestWhenInUseAuthorization()
    }
    
    func initializeLocation() {
        locationManagaer = CLLocationManager()
        locationManagaer.delegate = self
        locationManagaer.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationTracking(){
        self.initializeLocation()
        locationManagaer.startUpdatingLocation()
    }
    
    func stopLocationTracking(){
        self.initializeLocation()
        locationManagaer.stopUpdatingLocation()
    }
    
    func getLocation(_ address : String , completionHandler : @escaping (_ location : CLLocationCoordinate2D?) -> Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completionHandler(nil)
                return
            }
            completionHandler(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else {
            locationDelegate?.getCurrentLocation(coordinate: nil)
            return
        }
        locationDelegate?.getCurrentLocation(coordinate: coordinate)
    }
}
