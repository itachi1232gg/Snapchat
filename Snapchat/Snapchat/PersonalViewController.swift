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
        static var ShowCamara = "Show Camara"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let changePageUpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PersonalViewController.goToCamara))
        changePageUpSwipe.direction = .Up
        self.view.addGestureRecognizer(changePageUpSwipe)
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
