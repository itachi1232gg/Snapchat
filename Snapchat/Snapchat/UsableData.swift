//
//  File.swift
//  Test
//
//  Created by ailina on 16/10/2.
//  Copyright © 2016年 cole. All rights reserved.
//

import Foundation
import UIKit

class UsableData{
    
    static var myUsername = "xdxlwx"
    
    static func getFriendsWithUsername() -> [User]?{
        //        if myUsername != nil{
        //通过自己的用户名获取朋友列表
        let user1 = User(id: 1, name: "Cole", pwd: "keke")
        let user2 = User(id: 2, name: "Super", pwd: "1")
        let user3 = User(id: 3, name: "wow", pwd: "2")
        
        var users: [User] = []
        users.append(user1)
        users.append(user2)
        users.append(user3)
        return users
        //        }
        //        return nil
    }
    
    static func usersWantToAddMe() -> [User]?{
        //        if myUsername != nil{
        //通过自己的用户名获取想添加我为好友的人
        let user1 = User(id: 1, name: "Cole", pwd: "keke")
        let user2 = User(id: 2, name: "Super", pwd: "1")
        let user3 = User(id: 3, name: "wow", pwd: "2")
        
        var users: [User] = []
        users.append(user1)
        users.append(user2)
        users.append(user3)
        return users
        //        }
        //        return nil
    }

    
    static func getOneFriendWithMyUserName(name: String?) -> User?{
        //通过自己的用户名加好友名获取朋友
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
    
    static func addFriend(name: String?) -> Bool{
        //添加朋友到自己的朋友列表，要用自己的用户名！
        return true
    }
    
    static func sendFriendRequest(name: String?) -> Bool{
        //发送添加朋友请求到指定用户，要用自己的用户名！
        return true
    }
    
    static func readStories() -> [[ImageObject]]{
        //通过自己的用户名读取自己的stories
        var tempImageObject1 = ImageObject()
        tempImageObject1.innerImage = UIImage(named: "bridge")
        tempImageObject1.isSelect = false
        tempImageObject1.timer = 1.0
        var tempImageObject2 = ImageObject()
        tempImageObject2.innerImage = UIImage(named: "mountain")
        tempImageObject2.isSelect = false
        tempImageObject2.timer = 2.0
        var tempImageObject3 = ImageObject()
        tempImageObject3.innerImage = UIImage(named: "sunset")
        tempImageObject3.isSelect = false
        tempImageObject3.timer = 3.0
        var tempArray1: [ImageObject] = []
        tempArray1.append(tempImageObject3)
        tempArray1.append(tempImageObject1)
        tempArray1.append(tempImageObject2)
        var tempArray2: [ImageObject] = []
        tempArray2.append(tempImageObject1)
        tempArray2.append(tempImageObject2)
        var tempStoriesArray: [[ImageObject]] = []
        tempStoriesArray.append(tempArray1)
        tempStoriesArray.append(tempArray2)
        return tempStoriesArray
    }
    
    static func readSnaps() -> [ImageObject]{
        //通过自己的用户名读取自己的Snaps
        var imageArray: [ImageObject] = []
        for _ in 0...10{
            var tempImageObject = ImageObject()
            tempImageObject.innerImage = UIImage(named: "image1")
            tempImageObject.isSelect = false
            imageArray.append(tempImageObject)
        }
        return imageArray
    }
    
    static func deleteSelectedSnaps(selectedSnaps: [ImageObject]) -> Bool{
        //删除本用户名的所选snaps
        return true
    }
    
    static func makeStoriesFromSelectedSnaps(selectedSnaps: [ImageObject]) -> Bool{
        //将所选snaps变成stories
        return true
    }
    
    //没用，在想要不要删stories，有点麻烦
    static func deleteSelectedStories(selectedStories: [[ImageObject]]) -> Bool{
        //删除本用户名的所选stories
        return true
    }
    
    static func makeSnapFromImage(image: ImageObject) -> Bool{
        return true
    }
}
