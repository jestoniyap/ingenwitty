//
//  Client.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/10/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation
import UIKit

let baseUrl = "http://127.0.0.1:8000/"
let authenticateUrl = "http://127.0.0.1:8000/api/authenticate/"
let requestTokenUrl = "http://127.0.0.1:8000/oauth2/access_token/"

let clientId = "8525ee8e82454571f09f"
let clientSecret = "d9af36caeb89b99b94475058399e223d1a087ff6"


class Client {
    
    class func authenticateWithCredentials(params: Dictionary<String, String>, completion:(data: NSData?, error: NSError?) -> Void) {
        
        let username = params["username"] as String!
        let password = params["password"] as String!
        
        let payload = "grant_type=password" + "&username=\(username)" + "&password=\(password)" +
            "&client_id=\(clientId)" + "&client_secret=\(clientSecret)";
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: requestTokenUrl)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json = JSON(data: data)
            println("RESULT: ")
            println(json)
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.ingenuityph", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    if let accessToken = json["access_token"].stringValue{
                        println("access_token: " + accessToken)
                        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
                    }
                    completion(data: data, error: nil)
                }
            }
        })
        
        task.resume()
        
    }
    
    class func getRequestFromResource(resource: String, completion:(data: NSData?, error: NSError?) -> Void) {
        let requestUrl = baseUrl + resource + "/"
        
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as String
        let authString = "Bearer \(accessToken)"
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        request.HTTPMethod = "GET"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            let json = JSON(data: data)
            println("RESULT: ")
            println(json)
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
    
    class func postRequestToResource(resource: String, params: Dictionary<String, String>, completion:(data: NSData?, error: NSError?) -> Void) {
        let requestUrl = baseUrl + resource + "/"
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as String
        let authString = "Bearer \(accessToken)"
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.HTTPMethod = "POST"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            let json = JSON(data: data)
            println("RESULT: ")
            println(json)
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
    
    class func downloadImageAsync(urlString: String, completion:(image: UIImage?, error: NSError?) -> Void)
    {
        var url: NSURL
        var firstChar = urlString[urlString.startIndex]
        
        if firstChar == "/" {
            let newUrl = baseUrl + dropFirst(urlString)
            println("MISSING BASE URL! APPENDED BASE URL:")
            println(newUrl)
            url = NSURL(string: newUrl)!
        }else{
            url = NSURL(string: urlString)!
        }
        
        var imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                if let responseError = error {
                    completion(image: UIImage(data: data), error: responseError)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        var statusError = NSError(domain:"com.ingenuityph", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                        completion(image: UIImage(data: data), error: statusError)
                    } else {
                        completion(image: UIImage(data: data), error: error)
                    }
                }
        })
    }
}