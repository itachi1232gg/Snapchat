//
//  ChatViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    private struct Storyboard
    {
        static var ShowCamara = "Show Camera"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let changePageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.goToCamara))
        changePageLeftSwipe.direction = .Left
        self.view.addGestureRecognizer(changePageLeftSwipe)
        // Do any additional setup after loading the view.
    }
    
    func goToCamara()
    {
        performSegueWithIdentifier(Storyboard.ShowCamara, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }

}
