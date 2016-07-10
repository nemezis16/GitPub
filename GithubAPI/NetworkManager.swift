//
//  NetworkManager.swift
//  GithubAPI
//
//  Created by Roman Osadchuk on 09.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    let defaultSession :NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func fetchDataFromURL(url: NSURL,resopnseCompletion completion: (data: NSData?,response: NSURLResponse?,error: NSError?) -> Void) {
        
        let request = NSURLRequest(URL: url)
        let task = defaultSession.dataTaskWithRequest(request, completionHandler: completion)
        task.resume()
    }
    
    func fetchBatchDataFromURLs(urls: Array<NSURL>, completion: (dataArray: [NSData], responsesArray: [NSURLResponse], error: NSError?) -> Void) {
        let tasksGroup = dispatch_group_create()
        let mainQueue = dispatch_get_main_queue()
        
        var storedError: NSError?
        var dataArray: [NSData] = []
        var responsesArray: [NSURLResponse] = []
        
        for url in urls {
            guard (storedError == nil) else {
                dispatch_group_notify(tasksGroup, mainQueue, {
                    completion(dataArray: dataArray, responsesArray: responsesArray, error: storedError)
                })
                return
            }
            dispatch_group_enter(tasksGroup)
            self.fetchDataFromURL(url, resopnseCompletion: { (data, response, error) in
                
                guard (error == nil) else {
                    storedError = error
                    dispatch_group_leave(tasksGroup)
                    return
                }
            
                dataArray.append(data!)
                responsesArray.append(response!)
                dispatch_group_leave(tasksGroup)
            })
        }
        
        dispatch_group_notify(tasksGroup, mainQueue, {
            completion(dataArray: dataArray, responsesArray: responsesArray, error: storedError)
        })
    }
    
}
