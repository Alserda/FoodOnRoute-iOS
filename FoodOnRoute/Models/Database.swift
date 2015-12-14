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
    let stands = List<Stand>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}