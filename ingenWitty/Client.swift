//
//  Client.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/10/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

let baseUrl = "http://127.0.0.1:8000"
let authenticateUrl = "http://127.0.0.1:8000/api/authenticate/"

let cliendId = "c7f709cc6ae2f0123e70"
let clientSecret = "c5d803ba1c0abc59422e5bf1f5b1b6a1631f1767"

let UsersURL = "http://127.0.0.1:8000/users/"

class Client {
    
    class func authenticateWithCredentials(params: Dictionary<String, String>, completion:(data: NSData?, error: NSError?) -> Void) {
        
        var request = NSMutableURLRequest(URL: NSURL(string: authenticateUrl)!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let username = params["username"] as String!
        let password = params["password"] as String!
        let credentialsString = "\(username):\(password)"
        let credentialsData = credentialsString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = credentialsData!.base64EncodedStringWithOptions(nil)
        
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.ingenuityph", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        task.resume()
        
    }
    
    class func getRequestFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = "admin:admin"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.ingenuityph", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}