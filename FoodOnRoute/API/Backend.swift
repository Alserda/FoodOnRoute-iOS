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

struct endpoint {
//    static let foodOnRouteBaseURL : String = "http://staging.foodonrouteapp.nl/"
    static let foodOnRouteBaseURL : String = "http://staging.foodonrouteapp.nl/api/"
//    static let foodOnRouteStandsIndex : String = endpoint.foodOnRouteBaseURL + "stands.json"
    static let foodOnRouteStandsIndex : String = endpoint.foodOnRouteBaseURL + "stands"
}

class Backend {
    func retrievePath(endpoint: URLStringConvertible, completion: (response: JSON) -> (), failed: (error: NSError) -> ()) -> Void {
        Alamofire
            .request(.GET, endpoint, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                    case .Failure(let error):
                        print(error)
                        print("Hij dut nait")
                        failed(error: error)
                    case .Success:
                        let retrievedJSON = JSON(response.result.value!)
                        completion(response: retrievedJSON)
                    }
        }
    }
    
    func postRequest(endpoint: URLStringConvertible, params: [String : NSObject], completion: (response: JSON) -> ()) -> Void {
        Alamofire
            .request(.POST, endpoint, parameters: params, encoding: .JSON)
            .responseJSON { response in
                switch response.result {

                case .Failure(let error):
                    print(error)
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(response: json)
                        print("JSON: \(json)")
                    }
                }
        }
    }
}

