//
//  WAPlaceCell.swift
//  WAFair
//
//  Created by Shudhanshu on 27/06/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import UIKit

class WAPlaceCell: UICollectionViewCell {
    
    @IBOutlet weak var cityName : UILabel!
    @IBOutlet weak var cityTemp : UILabel!
    @IBOutlet weak var citySunRise : UILabel!
    @IBOutlet weak var citySunSet : UILabel!
    @IBOutlet weak var cityWeatherDesc : UILabel!
    @IBOutlet weak var icon : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellBackgroundGradient()
    }
    
    func updateView(object : WeatherResponse , selectedData : WeatherData){
        cityName.text = object.city.name
        let tempObject = WAUtility.sharedInstance.getTodaysTempertaure(selectedData)
        WANetworkCaller.getICONData(tempObject.1) { (data) in
            DispatchQueue.main.async {
                self.cityTemp.text = tempObject.0
                self.cityWeatherDesc.text = tempObject.2
                if let data = data{
                    self.icon.image = UIImage(data: data)
                }else{
                    self.icon.image = UIImage(named: "AppIcon")
                }
            }
        }
        citySunRise.text = "\(sunrise) \(WAUtility.sharedInstance.getTime(object.city.sunrise))"
        citySunSet.text = "\(sunset) \(WAUtility.sharedInstance.getTime(object.city.sunset))"
    }

}
