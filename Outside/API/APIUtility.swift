//
//  APIUtility.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/18/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

extension BaseAPI {
    func getCall( _ function : String? = nil, _ url : URL? = nil, path: String? = nil,parameters : [String: String],
         completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {

         let request: NSMutableURLRequest!
         if let url = url {
             request = NSMutableURLRequest(url: url)
         } else if (path != nil){
            request = NSMutableURLRequest(url: buildURL(APIConstants.baseEndpoint, path!, parameters, withPathExtension: function))
         } else {
            request = nil
        }
         let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
             func captureIssue(_ error: String) {
                 completionHandlerForGET(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : error]))
             }
             if let error = error {
                 if (error as NSError).code == URLError.cancelled.rawValue {
                     completionHandlerForGET(nil, nil)
                 } else {
                     captureIssue("Error in Response : \(error.localizedDescription)")
                 }
                 return
             }
             guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                 captureIssue("Your request returned a status code other than 2xx!")
                 return
             }

             guard let data = data else {
                 captureIssue("Error in Data!")
                 return
             }

             completionHandlerForGET(data, nil)

         }
         task.resume()
         return task
     }
     
    public func buildURL(_ host: String, _ path:String ,_ apiParameters: [String: String], withPathExtension: String? = nil) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path + (withPathExtension ?? "")
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in apiParameters {
            let queryItem = URLQueryItem(name: key, value: value)
            urlComponents.queryItems!.append(queryItem)
        }
        print(urlComponents.url!.absoluteString)
        return urlComponents.url!
    }
}
