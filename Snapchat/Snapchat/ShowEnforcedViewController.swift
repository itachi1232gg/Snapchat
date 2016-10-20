//
//  ShowEnforcedViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/16.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ShowEnforcedViewController: UIViewController {
    
    var story: [ImageObject]? //The only KEY value to set
    
    @IBOutlet weak var segueToStories: UIButton!
    @IBOutlet weak var showEnforcedImageView: UIImageView!
    var currentImage: UIImage?
    var backTo: String?

    var currentIndex: Int = -1{
        didSet{
            if currentIndex >= showStory?.count{
                continueShowing = false
                goBack()
            }
        }
    }
    var continueShowing = true
    
    @IBOutlet weak var segueToMemories: UIButton!
    
    var showStory: [ImageObject]?{
        didSet{
            showEnforcedPicA()
        }
    }
    
    func showEnforcedPicA(){
        currentIndex += 1
        if continueShowing{
            showEnforcedImageView.image = showStory![currentIndex].innerImage
            NSTimer.scheduledTimerWithTimeInterval(
                showStory![currentIndex].timer,
                target: self,
                selector: #selector(ShowEnforcedViewController.showEnforcedPicA),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func showEnforcedPicB(){
        currentIndex += 1
        if continueShowing{
            showEnforcedImageView.image = showStory![currentIndex].innerImage
            NSTimer.scheduledTimerWithTimeInterval(
                showStory![currentIndex].timer,
                target: self,
                selector: #selector(ShowEnforcedViewController.showEnforcedPicB),
                userInfo: nil,
                repeats: false
            )
        }
        
        
    }
    
    func goBack(){
        print("BACKTO::\(backTo)")
        performSegueWithIdentifier(backTo!, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segueToStories.hidden = true
        segueToMemories.hidden = true
        showStory = story
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
