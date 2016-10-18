//
//  AddByUsernameTableViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/3.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddByUsernameTableViewController: UITableViewController, UITextFieldDelegate {
    
    let reusableCellIdentifier = "AddByUsername" //改完这个记得还要改下面的cell类名
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
            
        }
    }
    
    var searchText: String?{
        didSet{
            userData.removeAll()
            lastRequest = nil
            searchForUserData()
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
            var user: User?
            UsableData.usersRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
                let users = snapShot.value as! NSDictionary
                for key in users.allKeys{
                    let uid = key as! String
                    let friendname = users[uid]!["username"] as! String
                    if friendname == name{
                        user = User(uid: uid, username: friendname)
                        self.userData.append([user!])
                        //self.tableView.reloadData()
                    }
                    print("GetOneFriendUsername:\(friendname), uid:\(uid)")
                }
            }
        }
    }
    
    private func searchForUserData()
    {
        //        if let request = getOneFriendWithMyUserName(searchText){
        //
        ////            userData.append([request])
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
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //        userData = [UsableData.getData()!]
        
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
        if let userCell = cell as? AddByUsernameTableViewCell{
            userCell.cellContent = user
        }
        
        return cell
    }
}
