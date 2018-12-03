//
//  Category.swift
//  Todoey
//
//  Created by Lydia Marion on 12/3/18.
//  Copyright © 2018 Lydia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
