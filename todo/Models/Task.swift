//
//  Task.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import UIKit

class Task: Codable {
    var title: String
    var memo: String?
    var latitude: Double?
    var longitude: Double?
    
    init(title: String) {
        self.title = title
    }
}
