//
//  WACollectionView.swift
//  WAFair
//
//  Created by Shudhanshu on 27/06/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import UIKit

private let reusePlaceIdentifier = "WAPlaceCell"
private let reuseGraphIdentifier = "WAGraphCell"

class WACollectionView: UICollectionView , UICollectionViewDataSource{
    
    var weatherObject : WeatherResponse?
    var selectedWeatherDatas : [WeatherData]!
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.register(UINib(nibName: "WAPlaceCell", bundle: nil), forCellWithReuseIdentifier: reusePlaceIdentifier)
        self.register(UINib(nibName: "WAGraphCell", bundle: nil), forCellWithReuseIdentifier: reuseGraphIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = weatherObject {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusePlaceIdentifier, for: indexPath) as! WAPlaceCell
            if let object = weatherObject {
                cell.updateView(object: object ,selectedData: selectedWeatherDatas.first!)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGraphIdentifier, for: indexPath) as! WAGraphCell
            cell.cellUpdate(objects: selectedWeatherDatas)
            cell.segementControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusePlaceIdentifier, for: indexPath)
            return cell
        }
    }
    
    @objc func segmentValueChanged(_ segment : UISegmentedControl){
        
        guard let cell = segment.superview?.superview as? WAGraphCell else {
            return
        }
        cell.setUpGraph(segment.selectedSegmentIndex, objects: selectedWeatherDatas)
    }
}

extension WACollectionView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = weatherObject {
            let width = collectionView.frame.width
            var height = CGFloat(0)
            switch indexPath.row {
            case 0:
                height = 130
                break
            case 1:
                height = 300
                break
            default:
                return .zero
            }
            return CGSize(width: width, height: height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
}


