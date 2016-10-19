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
    
    var table : UITableView?
    var selectedCellID: String?

    
    private struct Storyboard
    {
        static var ShowCamera = "Show Camera"
        static var ShowDiscovery = "Show Discovery"
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








