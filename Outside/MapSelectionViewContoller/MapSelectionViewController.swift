//
//  MapSelectionViewController.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/22/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit
import MapKit

class MapSelectionViewController: UIViewController {
    
    var weatherData: [WeatherData?] = []
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPins(weatherData)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displayPins(_ pinsDetails: [WeatherData?]) {
        for eachPin in pinsDetails {
            let pin = MKPointAnnotation()
            let latitude = eachPin!.coord.lat
            let longitude = eachPin!.coord.lon
            pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            mapView.addAnnotation(pin)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

}
