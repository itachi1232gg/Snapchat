//
//  AddedMeTableViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/3.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class AddedMeTableViewController: UITableViewController {

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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
