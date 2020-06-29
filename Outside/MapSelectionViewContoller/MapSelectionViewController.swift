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
    
    //MARK:- Properties
    var weatherDataCollection: [WeatherData?] = []
    var pinMarking: MKPointAnnotation? = nil
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlaces(weatherDataCollection)
    }
    
    //MARK:- Method to Display Selected location on Map
    func showPlaces(_ pinsDetails: [WeatherData?]) {
        for eachPin in pinsDetails {
            let pin = MKPointAnnotation()
            let latitude = eachPin!.coord!.lat
            let longitude = eachPin!.coord!.lon
            pin.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
            if let name = eachPin?.name, name.count > 0 {
                pin.title = name
                pin.subtitle = "\(eachPin!.main!.temp!)\u{00B0}"
            } else {
                pin.title = "\(String(describing: latitude!)), \(String(describing: longitude!))"
                pin.subtitle = "\(eachPin!.main!.temp!)\u{00B0}"
            }
            
            mapView.addAnnotation(pin)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    //MARK:- Method to Select a location on Map
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
                                                    unit: UserDefaults.standard.bool(forKey: "isCelsius") ? "metric" : "imperial") { (weatherData, error) in
                self.weatherDataCollection.append(weatherData)
                if let weatherData = weatherData {
                    self.updateUIOnMainThread {
                        if let name = weatherData.name , name.count > 0{
                            self.pinMarking?.title = name
                            self.pinMarking?.subtitle = "\(weatherData.main!.temp!)\u{00B0}"
                        } else {
                            self.pinMarking?.title = "\(String(describing: weatherData.coord!.lat!)), \(String(describing: weatherData.coord!.lon!))"
                            self.pinMarking?.subtitle = "\(weatherData.main!.temp!)\u{00B0}"
                        }
                    }
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
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.isDraggable = true
        pinView!.image = UIImage(named: "mapIcon")
       
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.showAlert(message: "Invalid Link.")
        }
    }

    //MARK:- Navigation Method to Home screen.
    @IBAction func selectedDone(_ sender: Any) {
        let vc:HomeVC
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
        } else {
           vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
