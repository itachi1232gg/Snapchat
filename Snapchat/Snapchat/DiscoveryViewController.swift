//
//  DiscoveryViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DiscoveryViewController: UITableViewController, UIGestureRecognizerDelegate{
    var data = DiscoverData()
    
    var selectedCellID: String?
    
    typealias entryType = DiscoverData.Entry
    
    var places = [entryType]()
    
    var ref: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    

    
    
    override func viewWillAppear(animated: Bool) {
        if(places.count == 0 ){
            
            
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
                    self.places.append(discover)
                }
                self.tableView.reloadData()
                print("count2 = \(self.places.count)")
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target:target,
                                         action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        
        
        
        //  self.tableView.addGestureRecognizer(pan)
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
        
    }
    
    //    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    //        return false
    //    }
    
    //    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
    //            if let scroll = gestureRecognizer as? uis
    //            return false
    //        }
    //        return false
    //    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discovercell") as! DiscoverCell
        let entry = places[indexPath.row]
        print(String(entry.filename))
        let imageURL = NSURL(string: entry.filename)
        if let image = fetchImage(imageURL) {
            cell.bkImageView.image = image
        }
        cell.discoverTitle.text = entry.heading
        cell.discoverContent.text = entry.content
        cell.cellID = entry.discoverID
        //cell.imageURL = entry.filename
        //let image = entry.filename
        //cell.discoverTitle.text = "123"
        //cell.discoverContent.text = "456"
        
        return cell
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DiscoverCell
        selectedCellID = cell.cellID
        print("cellID = \(selectedCellID)")
        performSegueWithIdentifier("idt1", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "idt1"{
            let destinationVC = segue.destinationViewController as! DisplayViewController
            destinationVC.storyID = selectedCellID
        }
        
    }
    
}



