//
//  PersonalViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    private struct Storyboard
    {
        static var ShowCamera = "Show Camera"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let changePageUpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PersonalViewController.goToCamera))
        changePageUpSwipe.direction = .Up
        self.view.addGestureRecognizer(changePageUpSwipe)
        // Do any additional setup after loading the view.
    }

    func goToCamera()
    {
        performSegueWithIdentifier(Storyboard.ShowCamera, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }
    
}
