//
//  ViewController.swift
//  WAFair
//
//  Created by Shudhanshu on 13/05/20.
//  Copyright © 2020 Shudhanshu. All rights reserved.
//

import UIKit
import CoreLocation

let pickerBottomOpened = 0
let pickerBottomClosed = 260

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTxtField : UITextField!{
       didSet {
          cityTxtField.tintColor = UIColor.gray
          cityTxtField.setIcon(UIImage(imageLiteralResourceName: "Search"))
       }
    }
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var collectionView : WACollectionView!
    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var dateButton : UIButton!
    @IBOutlet var pickerBottomConstraint : NSLayoutConstraint!
    @IBOutlet var cityTopAnchor : NSLayoutConstraint!

    
    var weatherObject : WeatherResponse?
    var selectedDate : Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateButton.isHidden = true
        self.cityTopAnchor.constant = self.view.center.y - 30.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appBackgroundGradient()
        self.addSingleTapGesture()
        self.setupPicker()
    }
    
    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(animated)
        self.animateCityTextField()
        self.cityTxtField.becomeFirstResponder()
    }
    
    func setupPicker(){
        self.datePicker.minimumDate = Date()
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 4, to: Date())
        selectedDate = self.datePicker.date
    }
    
    func startLoader() {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoader(){
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
        
    func getWeatherData(_ cooridnate : CLLocationCoordinate2D){
        WANetworkCaller.getData(cooridnate.latitude, longitude: cooridnate.longitude) { (result) in
            switch result {
            case .success(let (response,data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200..<299 ~= statusCode  else {
                    print(WeatherServiceAPI.APIServiceError.invalidResponse)
                    return
                }
                do{
                    let values  = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherObject = values
                        self.reloadData()
                    }
                    
                }catch let error{
                    print(WeatherServiceAPI.APIServiceError.decodeError)
                    print(error)
                }
                break
            case .failure(_):
                print(WeatherServiceAPI.APIServiceError.apiError)
                break
            }
            DispatchQueue.main.async {
                self.stopLoader()
            }
        }
    }
    
    func getLocation(_ address : String){
        self.startLoader()
        WALocationHandler.sharedInstance.getLocation(address) { (coordinate) in
            guard let coordinate = coordinate else{
                DispatchQueue.main.async {
                    self.stopLoader()
                    self.showNoCityAlert()
                }
                return
            }
            self.getWeatherData(coordinate)
        }
    }
    
    @IBAction func selectDate(_ sender : UIButton){
        self.view.endEditing(true)
        if let _ = self.weatherObject {
            self.togglePicker(self.datePicker.isHidden)
        }else{
            self.showNoDataAlert()
        }
    }
    
    func togglePicker(_ show : Bool){
        self.datePicker.isHidden = !show
        UIView.animate(withDuration: 0.5, delay: 0.0, options:.curveEaseIn , animations: {
            self.pickerBottomConstraint.constant = CGFloat((show ? pickerBottomOpened : pickerBottomClosed))
            self.view.layoutIfNeeded()
        }) { (bool) in
        }
    }
    
    @IBAction func valueChanged(_ picker : UIDatePicker){
        selectedDate = picker.date
    }
    
    
    func reloadData(){
        if let reloadObject = self.weatherObject{
            let selectedObjects = WAUtility.sharedInstance.getSelectedWeatherData(self.selectedDate, object: reloadObject)
            self.collectionView.weatherObject = reloadObject
            self.collectionView.selectedWeatherDatas = selectedObjects
            self.collectionView.reloadData()
        }
    }
    
    func animateCityTextField(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options:.curveEaseIn , animations: {
            self.cityTopAnchor.constant = 16.0
            self.view.layoutIfNeeded()
        }) { (bool) in
            self.dateButton.isHidden = false
            self.cityTxtField.shake()
        }
    }
    
    @IBAction func pickerDone(){
        self.togglePicker(false)
        self.view.endEditing(true)
        reloadData()
    }
    
    @IBAction func pickerCancel(){
        self.view.endEditing(true)
        self.togglePicker(false)
    }
    
}

extension ViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let _ = textField.text else {
            return
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        WALocationHandler.sharedInstance.stopLocationTracking()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let address = textField.text else {
            return false
        }
        self.getLocation(address)
        textField.resignFirstResponder()
        return true
    }
}

