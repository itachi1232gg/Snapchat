//
//  DiscoveryViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class DiscoveryViewController: UITableViewController, UIGestureRecognizerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        

        
        let pan = UIPanGestureRecognizer(target:target,
                                         action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if self.childViewControllers.count == 1 {
//            return false
//        }
//        return true
//        
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let data = Data()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discovercell") as! DiscoverCell
        let entry = data.places[indexPath.row]
        let image = UIImage(named: entry.filename)
        cell.bkImageView.image = image
        cell.headingLabel.text = entry.heading
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }
    
}



