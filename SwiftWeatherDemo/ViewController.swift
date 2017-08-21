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
        let params = ["lat": latitude, "lon": longitude, "cnt": 0, "appid": "4f4be8fe7031dddd5dec789e01c1b3ac"]
        manager.get(url, parameters: params,
                success: {
                    (operation: URLSessionDataTask!, responseObiect: Any!) in
                    print("JSON:" + (responseObiect as AnyObject).description)
                },
                failure: {
                    (operation: URLSessionDataTask?, error: Error!) in
                    print("Error:" + error.localizedDescription)
                })

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
