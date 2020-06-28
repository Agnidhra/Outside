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
    
    //MARK:- Method to Validate a record exists in Data Base
    func checkIfDataIsAlreadySaved(_ latitude: Double, _ longitude: Double) -> Bool{
        do {
             if (try CoreDataStackMethods.getSharedInstance().getAllCoordinates(
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
    
    //MARK:- Method to add and save data in Data Base if not present
    func checkAndSaveData(latitude: Double, longitude: Double){
        if !checkIfDataIsAlreadySaved(latitude, longitude) {
            _ = SavedCoordinates(
                    latCoordinate: latitude,
                    longCoordinate: longitude,
                               context: CoreDataStackMethods.getSharedInstance().currentMOContext)
                self.saveCurrentContext()
        }
    }
    
    //MARK:- Method to Check and Delete Data from DataBase if present.
    func checkAndDeleteData(latitude: Double, longitude: Double){
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
        }
    }   
}
