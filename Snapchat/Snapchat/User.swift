//
//  User.swift
//  Test
//
//  Created by ailina on 16/10/2.
//  Copyright © 2016年 cole. All rights reserved.
//

import Foundation

class User{
    var userId: Int
    var name: String
    var pwd: String
    
    init(id: Int, name: String, pwd: String) {
        userId = id
        self.name = name
        self.pwd = pwd
    }
}
