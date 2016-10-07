//
//  ChatListViewController.swift
//  Snapchat
//
//  Created by H&H on 2016/10/7.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chatingList: UITableView!
    
    private struct internalData{
        static var users: [String] = ["A","B","C","D"]
        static var searchUsers: [String] = []
        static var cells: String = "Chating One"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        internalData.searchUsers = internalData.users
        self.searchBar.delegate = self
        self.chatingList.delegate = self
        self.chatingList.dataSource = self
        self.chatingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: internalData.cells)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return internalData.searchUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = chatingList.dequeueReusableCellWithIdentifier(internalData.cells, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = internalData.searchUsers[indexPath.row]
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            internalData.searchUsers = internalData.users
        }else{
            internalData.searchUsers = []
            for user in internalData.users{
                if user.lowercaseString.hasPrefix(searchText.lowercaseString){
                    internalData.searchUsers.append(user)
                }
            }
        }
                self.chatingList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let theOne = sender as! UITableViewCell?{
            let desitination = segue.destinationViewController
            desitination.navigationController?.title = theOne.textLabel?.text
        }
        
    }
    // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
}
