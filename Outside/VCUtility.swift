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
}
