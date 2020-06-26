//
//  BaseAPI.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/18/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

class BaseAPI {
    var session = URLSession.shared
    private var actions: [String: URLSessionDataTask] = [:]
    
    class func sharedInstance() -> BaseAPI {
        struct Singleton { static var shared = BaseAPI() }
        return Singleton.shared
    }
    
    func getWeatherData(latitude: Double, longitude: Double, completion: @escaping (_ result: WeatherData?, _ error: Error?) -> Void) {
        let parameters = [ "lat":"\(latitude)",
            "lon":"\(longitude)",
            "appid": "c9a9c5b2931b82c759f7c418dc670cc4",
            "units":"metric"]
        //getCall(APIConstants.path, parameters: parameters, completionHandlerForGET: <#T##(Data?, NSError?) -> Void#>)
        
        getCall(path: APIConstants.shortDataPath, parameters: parameters) { (data, error) in
            if let error = error { completion(nil, error); return }
            guard let data = data else {
                completion(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to Get Information."]))
                return
            }
            
            do {
                let pr = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(pr, nil)
            } catch { completion(nil, error) }
            
        }
    }
    
    func getDetailedWeatherData(latitude: Double, longitude: Double, completion: @escaping (_ result: WeatherDataDetailed?, _ error: Error?) -> Void) {
        let parameters = [ "lat":"\(latitude)",
            "lon":"\(longitude)",
            "appid": APIConstants.APIKEY,
            "exclude":"minutely",
            "units":"metric"]
        
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

