//
//  AddFriendsTableViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/4.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class AddFriendsTableViewController: UITableViewController, Shareable,CNContactPickerDelegate,CNContactViewControllerDelegate {
    private var username: String = "xdxlwx"
    
    @IBAction func socialShareButton(sender: UIButton) {
        share(sender, text: username, url: nil, image: nil)
    }
    
    @IBAction func addressBookButton(sender: UIButton) {
        addressBookStore = CNContactStore()
        checkContactsAccess();
    }
    private var addressBookStore: CNContactStore!
    private var menuArray: NSMutableArray?
    let picker = CNContactPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
        // Update our UI if the user has granted access to their Contacts
        case .Authorized:
            self.showContactsPicker()
            
        // Prompt the user for access to Contacts if there is no definitive answer
        case .NotDetermined :
            self.requestContactsAccess()
            
        // Display a message if the user has denied or restricted access to Contacts
        case .Denied,
             .Restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                                          message: "Please Enable permission! in settings!.",
                                          preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func requestContactsAccess() {
        
        addressBookStore.requestAccessForEntityType(.Contacts) {granted, error in
            if granted {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showContactsPicker()
                    return
                }
            }
        }
    }
    
    
    //Show Contact Picker
    private  func showContactsPicker() {
        
        picker.delegate = self
        self.presentViewController(picker , animated: true, completion: nil)
        print("showing")
        
    }
    
    
    //    optional public func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
