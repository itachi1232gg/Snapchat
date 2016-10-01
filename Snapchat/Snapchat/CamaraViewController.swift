//
//  CameraViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/1.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    private struct Storyboard
    {
        static var ShowStories = "Show Stories"
        static var ShowMemories = "Show Memories"
        static var ShowChat = "Show Chat"
        static var ShowPersonal = "Show Personal"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let changePageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToStories))
        changePageLeftSwipe.direction = .Left
        self.view.addGestureRecognizer(changePageLeftSwipe)
        
        let changePageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToChat))
        changePageRightSwipe.direction = .Right
        self.view.addGestureRecognizer(changePageRightSwipe)
        
        let changePageUpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToMemories))
        changePageUpSwipe.direction = .Up
        self.view.addGestureRecognizer(changePageUpSwipe)
        
        let changePageDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToPersonal))
        changePageDownSwipe.direction = .Down
        self.view.addGestureRecognizer(changePageDownSwipe)
    }
    
    func goToStories()
    {
        performSegueWithIdentifier(Storyboard.ShowStories, sender: nil)
    }
    
    func goToChat()
    {
        performSegueWithIdentifier(Storyboard.ShowChat, sender: nil)
    }
    
    func goToMemories()
    {
        performSegueWithIdentifier(Storyboard.ShowMemories, sender: nil)
    }
    
    func goToPersonal()
    {
        performSegueWithIdentifier(Storyboard.ShowPersonal, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }
}
