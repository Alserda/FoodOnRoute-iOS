//
//  Storage.swift
//  locationsaver
//
//  Created by Peter Alserda on 24/11/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import Foundation
import RealmSwift


class Stand: Object {
    dynamic var id : Int = 0
    dynamic var name : String = ""
    dynamic var latitude : Double = 0.0
    dynamic var longitude : Double = 0.0
    let products = List<Product>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Product: Object {
    dynamic var id : Int = 0
    dynamic var name : String = ""
    var stands: [Stand] {
        // Realm doesn't persist this property because it only has a getter defined
        // Define "stands" as the inverse relationship to Stand.products
        return linkingObjects(Stand.self, forProperty: "products")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}