//
//  ToDoItem.swift
//  ToDoey
//
//  Created by Rajesh Karmaker on 22/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
