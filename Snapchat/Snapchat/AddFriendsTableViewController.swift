//
//  AddFriendsTableViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/4.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class AddFriendsTableViewController: UITableViewController, Shareable {
    private var username: String = "xdxlwx"
    @IBAction func socialShareButton(sender: UIButton) {
        share(sender, text: username, url: nil, image: nil)
    }
    /*
    //MARK: 获取的内容
    private var userData = [Array<User>]() {
        didSet{
            tableView.reloadData()
        }
    }
    //var userData:[Array<String>] = [["Add by 1", "Add by 2", "Add by 3"]]
    
    //MARK: 控制cell的的大小与内容相适应
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        userData = [UsableData.getData()!]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AddedMeFriends", forIndexPath: indexPath)
        
        let user = userData[indexPath.section][indexPath.row]
        if let userCell = cell as? AddedMeTableViewCell{
            userCell.cellContent = user
        }
        
        return cell
    }
    */
}
