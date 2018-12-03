//
//  Item.swift
//  Todoey
//
//  Created by Lydia Marion on 12/3/18.
//  Copyright © 2018 Lydia. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
