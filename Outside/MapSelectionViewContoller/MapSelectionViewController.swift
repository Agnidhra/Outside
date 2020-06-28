//
//  MapSelectionViewController.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/22/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit
import MapKit

class MapSelectionViewController: UIViewController, MKMapViewDelegate {
    
    var weatherDataCollection: [WeatherData?] = []
    @IBOutlet weak var mapView: MKMapView!
    var pinMarking: MKPointAnnotation? = nil
    var isCelsius: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPins(weatherDataCollection)
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
            let latitude = eachPin!.coord!.lat
            let longitude = eachPin!.coord!.lon
            pin.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
            pin.title = eachPin?.name
            mapView.addAnnotation(pin)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @IBAction func selectPinByLongPress(_ sender: UILongPressGestureRecognizer) {
            let location = sender.location(in: mapView)
            let locCoord = mapView.convert(location, toCoordinateFrom: mapView)
            
            if sender.state == .began {
                pinMarking = MKPointAnnotation()
                pinMarking!.coordinate = locCoord
                mapView.addAnnotation(pinMarking!)
            } else if sender.state == .changed {
                pinMarking!.coordinate = locCoord
            } else if sender.state == .ended {
                BaseAPI.sharedInstance().getWeatherData(latitude: (pinMarking!.coordinate.latitude),
                                                        longitude: (pinMarking!.coordinate.longitude),
                                                        unit: isCelsius! ? "metric" : "imperial") { (weatherData, error) in
                    if let weatherData = weatherData {
                        print(weatherData.timezone as Any)
                        self.pinMarking?.title = weatherData.name
                        self.weatherDataCollection.append(weatherData)
                        self.checkAndSaveData(latitude: (weatherData.coord?.lat)!, longitude: (weatherData.coord?.lon)!)
                    } else {
                        print(error.debugDescription)
                        self.showAlert(message: "No Information Found")
                        
                    }
                }
            }
        }
        
        
        //MARK:- MapView Delegate Methods
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = false
                pinView!.pinTintColor = .red
                pinView!.animatesDrop = true
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                self.showAlert(message: "Invalid Link.")
            }
        }

    @IBAction func selectedDone(_ sender: Any) {
        let vc:HomeVC
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
        } else {
           vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        }
//        vc.weatherData = self.weatherDataCollection
//        vc.isCoordinateUpdated = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
