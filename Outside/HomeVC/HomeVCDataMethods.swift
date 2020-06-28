//
//  HomeVCDataMethods.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/27/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit
extension  UIViewController{
    func checkIfDataIsAlreadySaved(_ latitude: Double, _ longitude: Double) -> Bool{
        do {
             if (try CoreDataStackMethods.getSharedInstance().getAllCoordinates(
                 //NSPredicate(format: "latitude == %@", argumentArray: [latitude]),
                NSPredicate(format: "(latitude == %@) AND (longitude == %@)", argumentArray: [latitude, longitude]),
                 
                 entityName: SavedCoordinates.tableName)!.count > 0) {
                return true
             } else {
                return false
            }
        } catch {
            print("error using predicate")
        }
        return false
    }
    
    func checkAndSaveData(latitude: Double, longitude: Double){
        if !checkIfDataIsAlreadySaved(latitude, longitude) {
            _ = SavedCoordinates(
                    latCoordinate: latitude,
                    longCoordinate: longitude,
                               context: CoreDataStackMethods.getSharedInstance().currentMOContext)
                self.saveCurrentContext()
        }
    }
    
//    func checkAndDeleteData(latitude: Double, longitude: Double){
//        print(checkIfDataIsAlreadySaved(latitude, longitude))
//        if checkIfDataIsAlreadySaved(latitude, longitude) {
//            CoreDataStackMethods.getSharedInstance().currentMOContext.delete(SavedCoordinates(latCoordinate: latitude, longCoordinate: longitude, context: CoreDataStackMethods.getSharedInstance().currentMOContext))
//                self.saveCurrentContext()
//        }
//    }
    
    func checkAndDeleteData(latitude: Double, longitude: Double){
        print(checkIfDataIsAlreadySaved(latitude, longitude))
        if checkIfDataIsAlreadySaved(latitude, longitude) {
            do {
                for object in  try CoreDataStackMethods.getSharedInstance().getAllCoordinates(
                    NSPredicate(format: "(latitude == %@) AND (longitude == %@)", argumentArray: [latitude, longitude]),
                    entityName: SavedCoordinates.tableName)! {
                        CoreDataStackMethods.getSharedInstance().currentMOContext.delete(object)
                        self.saveCurrentContext()
                }
                    
            } catch {
                print("error using predicate")
            }
            
//            CoreDataStackMethods.getSharedInstance().currentMOContext.delete(SavedCoordinates(latCoordinate: latitude, longCoordinate: longitude, context: CoreDataStackMethods.getSharedInstance().currentMOContext))
//                self.saveCurrentContext()
        }
    }
    
    
    
    
}
