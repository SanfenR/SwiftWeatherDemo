//
//  ViewController.swift
//  SwiftWeatherDemo
//
//  Created by fen san on 2017/8/15.
//  Copyright (c) 2017 sanfen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self

        locationManager.desiredAccuracy =
                kCLLocationAccuracyBest

     //   if(ios8()) {
        locationManager.requestAlwaysAuthorization()
       // }
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func ios8() -> Bool{
        return UIDevice.current.systemVersion == "8.0"
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if(location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)

            self.updateWeatherInfo(location.coordinate.latitude,
                    location.coordinate.longitude)

            locationManager.stopUpdatingLocation()
        }
    }

    func updateWeatherInfo(latitude: CLLocationDegrees,
                           longitude: CLLocationDegrees){

        let manager = AFHTTPRequestOperationManager()

        let url = "http://api.openweathermap.org/data/2.5/weather"

    }



    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
