//
//  ChatListViewController.swift
//  Snapchat
//
//  Created by H&H on 2016/10/7.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

//    @IBAction func cameraButton(sender: UIButton) {
//        performSegueWithIdentifier("ChatList To Camera", sender: nil)
//    }

    @IBOutlet weak var searchBar: UISearchBar!
    
//    @IBAction func storiesButton(sender: UIButton) {
//        performSegueWithIdentifier("ChatList To Stories", sender: nil)
//    }

    @IBOutlet weak var chatingList: UITableView!
    
    private struct internalData{
        static var users: [String] = ["A","B","C","D"]
        static var searchUsers: [String] = []
        static var cells: String = "Chating One"
    }
    
//    @IBAction func DoneCloseKeyBoard(sender: AnyObject) {
//        searchBar.resignFirstResponder();
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGuesture.cancelsTouchesInView = false
        chatingList.addGestureRecognizer(tapGuesture)
        
        searchBar.returnKeyType = UIReturnKeyType.Done
        //ppp
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.chatingList.deselectRowAtIndexPath(indexPath, animated: true)
        //theOne = internalData.searchUsers[indexPath.row]
        let theOne = internalData.searchUsers[indexPath.row]
        performSegueWithIdentifier("ChatList to Chat", sender: theOne)
    }
    
    var theOne: String?
    
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
    
//    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
//        searchBar.resignFirstResponder()
//        return true
//    }
    
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("\(segue.identifier)")
//        let art = segue.identifier == "ChatList To Chat"
//        let art1 = segue.identifier! == "ChatList To Chat"
//        print("\(art)")
//        print("\(art1)")
        if segue.identifier == "ChatList to Chat"{
            let destination = segue.destinationViewController as! ChatViewController
            //print("\(theOne)")
            destination.navigationItem.title = sender as? String
        }
    }
    // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
}
