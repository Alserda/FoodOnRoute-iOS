//
//  Backend.swift
//  locationsaver
//
//  Created by Stefan Brouwer on 04-11-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// Set baseURL
//let baseURL = "http://www.foodonrouteapp.nl/"
//let baseURL = "http://192.168.99.100/"
let baseURL = "http://staging.foodonrouteapp.nl/"
let standsIndex = "\(baseURL)stands.json"

class ResponsePackage {
    var success = false
    var response: AnyObject? = nil
    var error: NSError? = nil
}

class Backend {

//    class func getStandsData(sentParameters: (success: Bool, json: JSON) -> Void) {
//        print("\(__FUNCTION__)")
//        
//        Alamofire.request(.GET, standsIndex)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    let henk = JSON(response.result.value!)
//                    sentParameters(success: true, json: henk)
//                    
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//    }
//    
//    func getStandsData(sentParameters: (success: Bool, json: JSON) -> Void) {
//        print("\(__FUNCTION__)")
//        
//        Alamofire.request(.GET, standsIndex)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    let henk = JSON(response.result.value!)
//                    sentParameters(success: true, json: henk)
//                    
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//    }
    
    func get(apiEndPoint: NSString, completion: (response: Bool) -> ()) -> Void {
        print(apiEndPoint)
        completion(response: false)
        
    }
}

