//
//  File.swift
//  Test
//
//  Created by ailina on 16/10/2.
//  Copyright © 2016年 cole. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let storage = FIRStorage.storage()

let storageRef = storage.referenceForURL("gs://snapchat-35d64.appspot.com")

class UsableData{
    
    //    static var myUsername = "cole"
    
    static let myUserID = FIRAuth.auth()?.currentUser?.uid
    
    static var myUsername: String = ""
    
//    static func getMyUsername() -> String{
//        var name: String = ""
//        print("my userId: \(myUserID)")
//        selfRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
//            if let me = snapShot.value as? NSDictionary{
//                name = me["username"] as! String
//                //            myUsername = name
//            }
//        }
//        print("myName is: \(name)")
//        return name
//    }
    
    static var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    static var usersRef: FIRDatabaseReference {
        return UsableData.mainRef.child("users").ref
    }
    
    static var selfRef: FIRDatabaseReference {
        return UsableData.usersRef.child(UsableData.myUserID!).ref
    }
    
    static var myFriendsRef: FIRDatabaseReference {
        return UsableData.selfRef.child("friends").ref
    }
    
    static var myFriendsReqReceivedRef: FIRDatabaseReference {
        return UsableData.selfRef.child("friendsReqReceived").ref
    }
    
    static var mySnapsRef: FIRDatabaseReference {
        return UsableData.selfRef.child("snaps").ref
    }
    
    static var myStoriesRef: FIRDatabaseReference {
        return UsableData.selfRef.child("stories").ref
    }
    
    static var downloadURL: NSURL?
    
    /*
     static func getFriendsWithUsername() -> [User]?{
     //        //        if myUsername != nil{
     //        //通过自己的用户名获取朋友列表
     //        let user1 = User(id: 1, name: "Cole", pwd: "keke")
     //        let user2 = User(id: 2, name: "Super", pwd: "1")
     //        let user3 = User(id: 3, name: "wow", pwd: "2")
     //
     //        var users: [User] = []
     //        users.append(user1)
     //        users.append(user2)
     //        users.append(user3)
     //        return users
     //        //        }
     //        //        return nil
     var userArray: [User] = []
     myFriendsRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
     let myFriends = snapShot.value as! NSDictionary
     for key in myFriends.allKeys {
     let friendname = key as! String
     let uid = myFriends[friendname]! as! String
     let user = User(uid: uid, username: friendname)
     print("FriendsUsername:\(friendname), uid:\(uid)")
     userArray.append(user)
     }
     }
     return userArray
     }
     */
    
    /*
     static func usersWantToAddMe() -> [User]?{
     //        if myUsername != nil{
     //通过自己的用户名获取想添加我为好友的人
     //        let user1 = User(id: 1, name: "Cole", pwd: "keke")
     //        let user2 = User(id: 2, name: "Super", pwd: "1")
     //        let user3 = User(id: 3, name: "wow", pwd: "2")
     //
     //        var users: [User] = []
     //        users.append(user1)
     //        users.append(user2)
     //        users.append(user3)
     //        return users
     //        }
     //        return nil
     var userArray: [User] = []
     myFriendsReqReceivedRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
     let myFriendsReq = snapShot.value as! NSDictionary
     for key in myFriendsReq.allKeys {
     let friendname = key as! String
     let uid = myFriendsReq[friendname]! as! String
     let user = User(uid: uid, username: friendname)
     print("wantToAddMeUsername:\(friendname), uid:\(uid)")
     userArray.append(user)
     }
     }
     return userArray
     }
     */
    
    /*
     static func getOneFriendWithMyUserName(name: String?) -> User?{
     //通过自己的用户名加好友名获取朋友
     //        if name != nil{
     //            let user1 = User(uid: "1", username: "Cole")
     //            let user2 = User(uid: "2", username: "Super")
     //            let user3 = User(uid: "3", username: "wow")
     //
     //            var users: [User] = []
     //            users.append(user1)
     //            users.append(user2)
     //            users.append(user3)
     //
     //            for user in users{
     //                if user.username == name{
     //                    return user
     //                }
     //            }
     //        }
     //        return nil
     
     var user: User?
     usersRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
     let users = snapShot.value as! NSDictionary
     for key in users.allKeys{
     let uid = key as! String
     let friendname = users[uid]!["username"] as! String
     if friendname == name{
     user = User(uid: uid, username: friendname)
     }
     print("GetOneFriendUsername:\(friendname), uid:\(uid)")
     }
     }
     return user
     }
     */
    
    static func addFriend(name: String?) -> Bool{
        //添加朋友到自己的朋友列表，要用自己的用户名！
        usersRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
            var user: User?
            let users = snapShot.value as! NSDictionary
            for key in users.allKeys{
                let uid = key as! String
                let friendname = users[uid]!["username"] as! String
                if friendname == name{
                    user = User(uid: uid, username: friendname)
                }
                print("addFriendUsername:\(friendname), uid:\(uid)")
            }
            //加为自己的朋友
            myFriendsRef.child(user!.username).setValue(user!.uid)
            //别人加自己为朋友
            //            let msgData2 = [
            //                myUsername: myUserID!
            //            ]
            usersRef.child(user!.uid).child("friends").child(myUsername).setValue(myUserID!)
            //删除friendsReq
            myFriendsReqReceivedRef.child(user!.username).setValue(nil)
        }
        
        return true
    }
    
    static func sendFriendRequest(name: String?) -> Bool{
        //发送添加朋友请求到指定用户，要用自己的用户名！
        var user: User?
        usersRef.observeEventType(.Value){ (snapShot: FIRDataSnapshot) in
            let users = snapShot.value as! NSDictionary
            for key in users.allKeys{
                let uid = key as! String
                let friendname = users[uid]!["username"] as! String
                if friendname == name{
                    user = User(uid: uid, username: friendname)
                }
                print("sendFriendReqUsername:\(friendname), uid:\(uid)")
            }
            let msgData = [
                myUsername: myUserID!
            ]
            usersRef.child(user!.uid).child("friendsReqReceived").setValue(msgData)
        }
        return true
    }
    
    /*
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
     */
    /*
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
     */
    
    static func deleteSelectedSnaps(selectedSnaps: [ImageObject]) -> Bool{
        //删除本用户名的所选snaps
        for snap in selectedSnaps{
            mySnapsRef.child(snap.imageId).setValue(nil)
        }
        return true
    }
    
    
    static func makeStoriesFromSelectedSnaps(selectedSnaps: [ImageObject]) -> Bool{
        //将所选snaps变成stories
        let storiesRef = myStoriesRef.childByAutoId().ref
        for snap in selectedSnaps{
            storiesRef.child("snaps").child(snap.imageId).child("url").setValue(snap.url?.absoluteString)
            storiesRef.child("snaps").child(snap.imageId).child("timer").setValue(String(snap.timer))
        }
        return true
    }
    
    //没用，在想要不要删stories，有点麻烦
    static func deleteSelectedStories(selectedStories: [[ImageObject]]) -> Bool{
        //删除本用户名的所选stories
        return true
    }
    
    static func makeSnapFromImage(image: ImageObject) -> Bool{
        let data: NSData = UIImageJPEGRepresentation(image.innerImage,1)!
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.stringFromDate(today)
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(date)
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.downloadURL = metadata!.downloadURL()
                print("URL: \(self.downloadURL?.absoluteString!)")
                let snapRef = mySnapsRef.childByAutoId().ref
                snapRef.child("url").setValue(self.downloadURL?.absoluteString)
                snapRef.child("timer").setValue(String(image.timer))
            }
        }
        return true
    }
}
