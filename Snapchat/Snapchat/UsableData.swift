//
//  File.swift
//  Test
//
//  Created by ailina on 16/10/2.
//  Copyright © 2016年 cole. All rights reserved.
//

import Foundation

class UsableData{
    
    static func getData() -> [User]?{
        let user1 = User(id: 1, name: "Cole", pwd: "keke")
        let user2 = User(id: 2, name: "Super", pwd: "1")
        let user3 = User(id: 3, name: "wow", pwd: "2")
        
        var users: [User] = []
        users.append(user1)
        users.append(user2)
        users.append(user3)
        return users
    }
    
    static func getDataWithUserName(name: String?) -> User?{
        if name != nil{
            let user1 = User(id: 1, name: "Cole", pwd: "keke")
            let user2 = User(id: 2, name: "Super", pwd: "1")
            let user3 = User(id: 3, name: "wow", pwd: "2")
            
            var users: [User] = []
            users.append(user1)
            users.append(user2)
            users.append(user3)
            
            for user in users{
                if user.name == name{
                    return user
                }
            }
        }
        return nil
    }
    
    static func addUser(name: String?) -> Bool{
        return true
    }
}
