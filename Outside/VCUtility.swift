//
//  VCUtility.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/25/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(withTitle: String = "Information", message: String, action: (() -> Void)? = nil) {
        updateUIOnMainThread {
            let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func updateUIOnMainThread(_ updateTheUI: @escaping () -> Void) {
        DispatchQueue.main.async {
            updateTheUI()
        }
    }
    func getImage(weather: String?) -> UIImage? {
        switch weather {
            case "Clear":
                return UIImage(named: "ClearDay")
            case "Clouds":
                return UIImage(named: "Clouds")
            case "Drizzle":
                return UIImage(named: "Drizzle")
            case "Haze":
                return UIImage(named: "Haze")
            case "Mist":
                return UIImage(named: "Mist")
            case "Rain":
                return UIImage(named: "Rain")
            case "Smoke":
                return UIImage(named: "Smoke")
            case "Snow":
                return UIImage(named: "Snow")
            case "Thunderstorm":
                return UIImage(named: "Thunderstorm")
            default:
                print("Weather not Predefined" )
            return nil
        }
    }
    
    func saveCurrentContext() {
        do {
            try CoreDataStackMethods.getSharedInstance().saveCurrentContext()
        } catch {
            showAlert(withTitle: "Error", message : "Encountered Some Issue While Saving Pin Location: \(error). Please Try Again")
        }
    }
}
