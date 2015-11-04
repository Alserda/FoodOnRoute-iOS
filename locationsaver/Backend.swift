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

class Backend {

    class func getStandsData() {
        print("\(__FUNCTION__)")
        
        Alamofire.request(.GET, standsIndex)
            .validate().responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Succesful")
                    
                    let JSON = response.result.value!
                    print("JSON: \(JSON)")
                    
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
}

