//
//  User.swift
//  Test
//
//  Created by ailina on 16/10/2.
//  Copyright © 2016年 cole. All rights reserved.
//

import Foundation

class User{
    var uid: String
    var username: String
    var lastname: String
    var firstname: String
    var email: String
    var mobilenum: String
    var favourite: String
    
    init(uid: String, username: String, lastname: String = "", firstname: String = "", email: String = "",
         mobilenum: String = "", favourite: String = ""){
        self.uid = uid
        self.username = username
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.mobilenum = mobilenum
        self.favourite = favourite
    }
}
