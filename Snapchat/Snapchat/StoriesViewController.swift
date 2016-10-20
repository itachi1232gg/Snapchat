//
//  StoriesViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StoriesViewController: UIViewController {
    
    @IBOutlet weak var storiesTableView: UITableView!
    @IBOutlet weak var segueToEnforced: UIButton!
    var selfSegueIdentifier = "Show Stories"
    var table : UITableView?
    var selectedCellID: String?
    
    var storiesArray:[[ImageObject]] = []
    
    func readMyFriendsId(){
        storiesArray = []
        UsableData.myFriendsRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let myFriendsId = snapShot.value as? NSDictionary{
                for myFriendId in myFriendsId.allValues{
                    let fid = myFriendId as! String
                    self.readStories(fid)
                    //                    let ffid = fid.allValues as! [AnyObject]
                    //                    for ffid in fid{
                    //                        let fffid = ffid as! String
                    //
                    //                    }
                    
                }
            }
        }
    }
    
    func readStories(myFriendId: String){
        UsableData.usersRef.child(myFriendId).child("stories").observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let myStories = snapShot.value as? NSDictionary{
                for key in myStories.allKeys {
                    let storiesId = key as! String
                    //if(self.lastkey == nil || (self.lastkey != nil && self.lastkey! == storiesId)){
                    var tempArray: [ImageObject] = []
                    let snaps = myStories[storiesId]?.allValues as! [NSDictionary]
                    for snapValue in snaps{
                        //                            let snapId = snapValue.allKeys as! String
                        let snapV = snapValue.allValues as! [NSDictionary]
                        //                            var urlString = ""
                        var url: NSURL?
                        var timer: Double?
                        for sn in snapV{
                            let strings = sn.allValues as! [AnyObject]
                            let timerString = strings[0] as! String
                            timer = Double(timerString)
                            let urlString = strings[1] as! String
                            url = NSURL(string: urlString)
                        }
                        var tempImageObject = ImageObject()
                        
                        //                            for value in snapV{
                        //                                if let urlstr = value as? String{
                        //                                    urlString = urlstr
                        //                                }
                        //                            }
                        //                            let urlString = snaps[snapId]!["url"] as! String
                        //                            let url = NSURL(string: urlString)
                        //                            let timerString = snaps[snapId]!["timer"]! as! String
                        //                            let timer = Double(timerString)
                        //                            let timer = 3.0
                        //                            print("readSnapsURL:\(urlString), timer:\(timerString)")
                        
                        var image:UIImage?
                        let gsReference = storage.referenceForURL(url!.absoluteString!)
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        gsReference.dataWithMaxSize(10 * 1024 * 1024) { (data, error) -> Void in
                            if (error != nil) {
                                print("ERROR: \(error)")
                            } else {
                                // Data for "images/island.jpg" is returned
                                image = UIImage(data: data!)
                                tempImageObject.innerImage = image
                                tempImageObject.isSelect = false
                                tempImageObject.timer = timer
                                self.storiesTableView.reloadData()
                            }
                        }
                        tempArray.append(tempImageObject)
                    }
                    
                    //self.lastkey = storiesId
                    self.storiesArray.append(tempArray)
                }
                
                //}
                
            }
        }
    }
    
    
    private struct Storyboard
    {
        static var ShowCamera = "Show Camera"
        static var ShowDiscovery = "Show Discovery"
        static var ShowEnforced = "Show Enforced"
    }
    
    typealias  typeStory = DiscoverData.Entry
    var storyList = [typeStory]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var categories = ["","Subscription List","live","friends stories"]
    
    
    override func viewWillAppear(animated: Bool) {
        if storyList.count == 0{
            getDiscoverListData()
        }
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        readMyFriendsId()
        segueToEnforced.hidden = true
        //Swipe gesture Recognizer -right and left
        let changePageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(StoriesViewController.goToCamera))
        
        changePageRightSwipe.direction = .Right
        self.view.addGestureRecognizer(changePageRightSwipe)
        let changePageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(StoriesViewController.goToDiscovery))
        changePageLeftSwipe.direction = .Left
        self.view.addGestureRecognizer(changePageLeftSwipe)
        
        // Do any additional setup after loading the view.
    }
    
    
    func goToCamera()
    {
        performSegueWithIdentifier(Storyboard.ShowCamera, sender: nil)
    }
    
    func goToDiscovery()
    {
        performSegueWithIdentifier(Storyboard.ShowDiscovery, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "idt2"{
            
            let destinationVC = segue.destinationViewController as! DisplayViewController
            destinationVC.storyID = selectedCellID
        }else if segue.identifier == Storyboard.ShowEnforced{
            if let svc = segue.destinationViewController.contentViewController as? ShowEnforcedViewController {
                svc.backTo = selfSegueIdentifier
                svc.story = sender as! [ImageObject]
            }
        }
        
    }
    
    var ref: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    private func fetchImage(imageURL: NSURL?) -> UIImage?{
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url){
                let image = UIImage(data: imageData)
                return image
            }
        }
        return nil
    }
    
    func getDiscoverListData() {
        
        if(storyList.count == 0 ){
            
            ref.child("discoverlist").observeEventType(FIRDataEventType.Value, withBlock: { (snapShot:FIRDataSnapshot) in
                
                
                let internalDatausers = (snapShot.value as? NSDictionary)!
                //            let count = internalDatausers.count
                let allkey = internalDatausers.allKeys
                //            let allvalues = internalDatausers.allValues
                //
                //            let value = internalDatausers.valueForKey("discover1")
                
                
                //            print ("Testing: \(internalDatausers)\n")
                //            print ("count : \(count)\n")
                //            print ("allkey : \(allkey)\n")
                //            print ("allvalue : \(allvalues)\n")
                //            print ("value1 : \(value)\n")
                
                for key in allkey {
                    
                    let value = internalDatausers.valueForKey(key as! String)
                    let heading = value?.valueForKey("heading") as! String
                    let content = value?.valueForKey("content") as! String
                    let image = value?.valueForKey("image") as! String
                    let discover = DiscoverData.Entry(fname: image, heading: heading, content: content, discoverID: key as! String)
                    self.storyList.append(discover)
                    
                }
                
                print("count2 = \(self.storyList.count)")
                self.view.setNeedsDisplay()
                self.table?.reloadData()
            })
        }
        
    }
}


extension StoriesViewController : UITableViewDelegate { }

extension StoriesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        table = tableView
        return categories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        print("row = " + String(indexPath.row))
        //        print("section  = " + String(indexPath.section))
        
        if storyList.count == 0{
            tableView.reloadData()
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("storiescell") as! CategoryRow
        cell.upperView = self
        cell.storyList = storyList
        print("****************\(storyList.count)")
        cell.tableIndexSection = indexPath.section
        cell.storiesArray = self.storiesArray
        return cell
        
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("storiescell") as! CategoryRow
    //        let selectedRow = cell.selectedSection
    //        let selectedSection = cell.tableIndexSection
    //
    //
    //
    //
    //        print("selectedRow = \(selectedRow)")
    //        print("selectedSection = \(selectedSection)")
    //
    //        performSegueWithIdentifier("idt2", sender: self)
    //    }
    
    
}








