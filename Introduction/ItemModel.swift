//
//  ItemModel.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/17/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import Foundation
import RealmSwift

class ItemModel: Object {
    @objc dynamic var content: String? = nil
    @objc dynamic var idx: Int = -1
}
