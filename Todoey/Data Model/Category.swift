//
//  Category.swift
//  Todoey
//
//  Created by Lydia Marion on 12/3/18.
//  Copyright © 2018 Lydia. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    // items is a relationship which means that a category can have items
    let items = List<Item>()
}
