//
//  Category.swift
//  ToDp
//
//  Created by ivan cardenas on 03/04/2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
