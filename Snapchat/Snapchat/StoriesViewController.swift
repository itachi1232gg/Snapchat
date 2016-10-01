//
//  StoriesViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {

    private struct Storyboard
    {
        static var ShowCamara = "Show Camara"
        static var ShowDiscovery = "Show Discovery"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let changePageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(StoriesViewController.goToCamara))
        changePageRightSwipe.direction = .Right
        self.view.addGestureRecognizer(changePageRightSwipe)
        
        let changePageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(StoriesViewController.goToDiscovery))
        changePageLeftSwipe.direction = .Left
        self.view.addGestureRecognizer(changePageLeftSwipe)
        // Do any additional setup after loading the view.
    }
    
    func goToCamara()
    {
        performSegueWithIdentifier(Storyboard.ShowCamara, sender: nil)
    }
    
    func goToDiscovery()
    {
        performSegueWithIdentifier(Storyboard.ShowDiscovery, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }

}
