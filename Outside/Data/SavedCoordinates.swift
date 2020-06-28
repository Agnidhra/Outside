//
//  SavedCoordinates.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/27/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

import Foundation
import CoreData

@objc(SavedCoordinates)
public class SavedCoordinates: NSManagedObject {
    
    static let tableName = "SavedCoordinates"
    
    convenience init(latCoordinate: Double, longCoordinate: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: SavedCoordinates.tableName, in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.latitude = latCoordinate
            self.longitude = longCoordinate
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}

extension SavedCoordinates {
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}


