//
//  MyFriendsTableViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/3.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyFriendsTableViewController: UITableViewController, UITextFieldDelegate {
    
    let reusableCellIdentifier = "MyFriends" //改完这个记得还要改下面的cell类名
    
    @IBOutlet weak var segueView: UIView!
    @IBOutlet weak var segueToMemories: UIButton!
    @IBOutlet weak var segueToPersonal: UIButton!
    @IBOutlet weak var segueToCamera: UIButton!
    var backTo: String?
    /***********************************************************/
    //forward message到聊天室
    //prepareSegue, 怎么才能传数据给聊天室并显示？
    //若message为nil，则是从personal进入没有message，不为nil就是从imageview forward的
    var message: ImageObject?{
        didSet{
            print("MyFriends message keke")
        }
    }
    /***********************************************************/
    @IBAction func segueTo(sender: UIBarButtonItem) {
        print("BACKTO::\(backTo)")
        performSegueWithIdentifier(backTo!, sender: nil)
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func getFriendsWithUsername(){
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
        UsableData.myFriendsRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let myFriends = snapShot.value as? NSDictionary{
                for key in myFriends.allKeys {
                    let friendname = key as! String
                    let uid = myFriends[friendname]! as! String
                    let user = User(uid: uid, username: friendname)
                    print("FriendsUsername:\(friendname), uid:\(uid)")
                    userArray.append(user)
                }
                self.userData = [userArray]
            }
        }
    }
    
    
    var searchText: String?{
        didSet{
            userData.removeAll()
            lastRequest = nil
            if searchText! == ""{
                //                userData = [UsableData.getFriendsWithUsername()!]
                getFriendsWithUsername()
            }else{
                searchForUserData()
            }
            
            
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: Fetching Friends
    
    private var friendsRequest: String? {
        if lastRequest == nil {
            if let query = searchText{
                return query
            }
        }
        return lastRequest
    }
    
    private var lastRequest: String?
    
    func getOneFriendWithMyUserName(name: String?){
        if(name != nil){
            UsableData.myFriendsRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
                if let myFriends = snapShot.value as? NSDictionary{
                    for key in myFriends.allKeys {
                        let friendname = key as! String
                        let uid = myFriends[friendname]! as! String
                        if friendname == name{
                            let user = User(uid: uid, username: friendname)
//                            user = User(uid: uid, username: friendname)
                            self.userData.append([user])
                            //self.tableView.reloadData()
                        }
                        
                        print("FriendsUsername:\(friendname), uid:\(uid)")
                    }
//                    if friendname == name{
//                        user = User(uid: uid, username: friendname)
//                        self.userData.append([user!])
//                        //self.tableView.reloadData()
//                    }
//                    print("GetOneFriendUsername:\(friendname), uid:\(uid)")
                }
            }
        }
    }
    
    private func searchForUserData()
    {
//        if let request = getOneFriendWithMyUserName(searchText){
//            
//            userData.append([request])
//        }
        
        getOneFriendWithMyUserName(searchText)
        
        /*{
         lastRequest = request
         //request.fetchTweets {  newTweets in
         //同步
         if request == lastRequest {
         if !newTweets.isEmpty {
         tweets.insert(newTweets, atIndex: 0)
         }
         }
         refreshControl?.endRefreshing()
         
         //}
         } else {
         self.refreshControl?.endRefreshing()
         }
         */
    }
    
    
    //MARK: 获取的内容
    private var userData = [Array<User>]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: 控制cell的的大小与内容相适应
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueToMemories.hidden = true
        segueView.hidden = true
        segueToPersonal.hidden = true
        segueToCamera.hidden = true
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //        userData = [UsableData.getFriendsWithUsername()!]
        getFriendsWithUsername()
        let tapToReset = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapToReset.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapToReset)
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer){
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    //MARK: 设置cell的section数量
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userData.count
    }
    
    //MARK: 设置cell的相应section的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userData[section].count
    }
    
    //MARK: 设置cell的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier, forIndexPath: indexPath)
        
        let user = userData[indexPath.section][indexPath.row]
        if let userCell = cell as? MyFriendsTableViewCell{
            userCell.cellContent = user
        }
        
        return cell
    }
    
}
