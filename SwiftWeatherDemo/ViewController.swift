//
//  ViewController.swift
//  SwiftWeatherDemo
//
//  Created by fen san on 2017/8/15.
//  Copyright (c) 2017 sanfen. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self

        locationManager.desiredAccuracy =
                kCLLocationAccuracyBest

        // if(ios8()) {
        locationManager.requestAlwaysAuthorization()
        // }
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func ios8() -> Bool {
        return UIDevice.current.systemVersion == "8.0"
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            self.updateWeatherInfo(latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func updateWeatherInfo(latitude: CLLocationDegrees,
                           longitude: CLLocationDegrees) {

        let manager = AFHTTPSessionManager()
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let appId = "4f4be8fe7031dddd5dec789e01c1b3ac"
        let params = ["lat": latitude,
                      "lon": longitude,
                      "appid": appId,
                      "cnt": 0] as [String: Any]

        manager.get(url, parameters: params,
                progress: { (progress: Progress) in print("progress") },
                success: { (operation: URLSessionDataTask!, responseObject: Any!)
                in
                    self.updateUISuccess(jsonResult:responseObject as! NSDictionary)
                },
                failure: { (operation: URLSessionDataTask?, error: Error!)
                in
                    print("Error: " + error.localizedDescription)
                })


    }

    private func updateUISuccess(jsonResult: NSDictionary!) {
        if let temp = (jsonResult["main"] as! NSDictionary)["temp"] as? Double {
            var temperature: Double

//            if((jsonResult["sys"] as! NSDictionary)["country"] as? String == "US") {
//                temperature = round((temp - 273.15) * 1.8 + 32)
//            } else {
//                temperature = round(temp - 273.15)
//            }

            temperature = round(temp - 273.15)

            self.temperature.text = "\(temperature)"
            self.temperature.font = UIFont.boldSystemFont(ofSize: 60)
            self.location.text = jsonResult["name"] as? String

            let weather =  (jsonResult["weather"] as?  NSArray)?[0] as? NSDictionary

            var condition = weather?["id"] as? Int
            var sunrise = (jsonResult["sys"] as? NSDictionary)?["sunrise"] as? Double
            var sunset = (jsonResult["sys"] as? NSDictionary)?["sunset"] as? Double


            var isNight = false
            var nowTime = NSDate().timeIntervalSince1970

            if(nowTime < sunrise! || nowTime > sunset!) {
                isNight = true
            }

            updateWeatherIcon(condition!, isNight)

        } else  {

        }
    }

    private func updateWeatherIcon(_ condition: Int, _ isNight: Bool) {
        //设置天气icon
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
