//
//  BaseAPI.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/18/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

class BaseAPI {
    
    //MARK:- Properties
    var session = URLSession.shared
    private var actions: [String: URLSessionDataTask] = [:]
    
    //MARK:- Method to get single shared instance the class
    class func sharedInstance() -> BaseAPI {
        struct Singleton { static var shared = BaseAPI() }
        return Singleton.shared
    }
    
    //MARK:- Method to Get basic weather data for a specific Coordinate
    func getWeatherData(latitude: Double, longitude: Double, unit:String, completion: @escaping (_ result: WeatherData?, _ error: Error?) -> Void) {
        
        //Initialize Parameters
        let parameters = [ "lat":"\(latitude)",
            "lon":"\(longitude)",
            "appid": APIConstants.APIKEY,
            "units":unit]
        
        //Method Call for getting API Details
        getCall(path: APIConstants.shortDataPath, parameters: parameters) { (data, error) in
            if let error = error { completion(nil, error); return }
            guard let data = data else {
                completion(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to Get Information."]))
                return
            }
            //Decoding the Response data
            do {
                let pr = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(pr, nil)
            } catch { completion(nil, error) }
        }
    }
    
    //MARK:- Method to Get Detailed weather data for a specific Coordinate
    func getDetailedWeatherData(latitude: Double, longitude: Double, unit:String, completion: @escaping (_ result: WeatherDataDetailed?, _ error: Error?) -> Void) {
        
        //Initialize Parameters
        let parameters = [ "lat":"\(latitude)",
            "lon":"\(longitude)",
            "appid": APIConstants.APIKEY,
            "exclude":"minutely",
            "units":unit]
        
        //Method Call for getting API Details
        getCall(path: APIConstants.detailedDataPath, parameters: parameters) { (data, error) in
            if let error = error { completion(nil, error); return }
            guard let data = data else {
                completion(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to Get Information."]))
                return
            }
            do {
                let pr = try JSONDecoder().decode(WeatherDataDetailed.self, from: data)
                completion(pr, nil)
            } catch { completion(nil, error)}
        }
    }
}

