//
//  Category.swift
//  ToDoey
//
//  Created by Rajesh Karmaker on 22/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<ToDoItem>()
}
