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
    static let foodOnRouteBaseURL : String = "http://staging.foodonrouteapp.nl/"
    static let foodOnRouteStandsIndex : String = endpoint.foodOnRouteBaseURL + "stands.json"
}

class Backend {
    func retrievePath(endpoint: URLStringConvertible, completion: (response: JSON) -> ()) -> Void {
        Alamofire
            .request(.GET, endpoint, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                    case .Failure(let error):
                        print(error)
                    case .Success:
                        let retrievedJSON = JSON(response.result.value!)
                        completion(response: retrievedJSON)
                    }
        }
    }
}

