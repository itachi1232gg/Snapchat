//
//  DiscoveryViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {

    private struct Storyboard
    {
        static var ShowStories = "Show Stories"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let changePageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DiscoveryViewController.goToStories))
        changePageRightSwipe.direction = .Right
        self.view.addGestureRecognizer(changePageRightSwipe)
        // Do any additional setup after loading the view.
    }
    
    func goToStories()
    {
        performSegueWithIdentifier(Storyboard.ShowStories, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }

}
