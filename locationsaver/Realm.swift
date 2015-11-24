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
    dynamic var id = ""
    dynamic var name = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}