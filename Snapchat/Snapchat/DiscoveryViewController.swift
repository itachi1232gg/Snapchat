//
//  DiscoveryViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController, UIGestureRecognizerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target:target,
                                         action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        //同时禁用系统原先的侧滑返回功能
        //self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
                             shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }

}
