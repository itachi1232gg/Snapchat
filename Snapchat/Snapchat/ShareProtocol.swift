//
//  ShareProtocol.swift
//  Snapchat
//
//  Created by ailina on 16/10/4.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

protocol Shareable {}

extension Shareable where Self: UIViewController{
    
    func share(sender: UIButton!, text: String?, url: NSURL?, image: UIImage?){
//        let firstActivityItem = "Text you want"
//        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
//        // If you want to put an image
//        let image : UIImage = UIImage(named: "image.jpg")!
        var msgToSent: [AnyObject] = []
        if text != nil{
            msgToSent.append(text!)
            print("TEXT\(text)")
        }
        if url != nil{
            msgToSent.append(url!)
            print("URL\(url)")
        }
        if image != nil{
            msgToSent.append(image!)
            print("IMAGE!!!")
        }

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: msgToSent, applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            //UIActivityType.postToWeibo
            //            UIActivityTypePrint,
            //            UIActivityTypeAssignToContact,
            //            UIActivityTypeSaveToCameraRoll,
            //            UIActivityTypeAddToReadingList,
            //            UIActivityTypePostToFlickr,
            //            UIActivityTypePostToVimeo,
            //            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
}
