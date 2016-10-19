//
//  StoriesViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import Firebase

class StoriesViewController: UIViewController{
    
    
    
    @IBOutlet weak var segueToEnforced: UIButton!
    
    private struct Storyboard
    {
        static var ShowCamera = "Show Camera"
        static var ShowDiscovery = "Show Discovery"
        static var ShowEnforced = "Show Enforced"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    var categories = ["","Subscription List","live","friends stories"]
    
    @IBOutlet weak var storiesTableView: UITableView!
//    var storiesArray:[[ImageObject]] = []
    
    var storiesArray:[[ImageObject]] = []
    
    func readStories(){
        UsableData.myStoriesRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        segueToEnforced.hidden = true
        readStories()
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        
//    }
}


extension StoriesViewController : UITableViewDelegate { }

extension StoriesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        print("row = " + String(indexPath.row))
        //        print("section  = " + String(indexPath.section))
        
        let cell = tableView.dequeueReusableCellWithIdentifier("storiescell") as! CategoryRow
        //send indexPath.section to collection view controller
        cell.tableIndexSection = indexPath.section
        cell.storiesArray = self.storiesArray
//        cell.collectionView.reloadData()
        return cell
        
        
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("You selected cell #\(indexPath.item)!")
//    }
//    
    
}








