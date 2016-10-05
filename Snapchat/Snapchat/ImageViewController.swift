//
//  ImageViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/4.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, Shareable {

    var pictureTimer: NSTimeInterval = 3.0
    var image: UIImage?
    var backTo: String?
    
    @IBOutlet weak var segueToCameraButton: UIButton!
    @IBOutlet weak var segueToMemoriesButton: UIButton!
//    private struct Storyboard{
//        static var ShowStories = "Show Stories"
//        static var ShowMemories = "Show Memories"
//        static var ShowChat = "Show Chat"
//        static var ShowPersonal = "Show Personal"
//        static var ShowPicture = "Show Picture"
//    }
    
    @IBOutlet weak var pictureTakenImageView: UIImageView!
    
    @IBAction func socialShareButton(sender: UIButton) {
        share(sender, text: nil, url: nil, image: pictureTakenImageView.image)
    }
    
    @IBAction func backToCamera(sender: UIButton) {
        print("BACKTO::\(backTo)")
        performSegueWithIdentifier(backTo!, sender: nil)
    }
    @IBOutlet weak var showPictureView: UIView!{
        didSet{
            initiateAlert()
        }
    }
    
    @IBAction func savePicture(sender: UIButton) {
        let imageTemp = pictureTakenImageView.image
        //let imageTemp = image                                                                //如果要编辑功能需要改这个变量
        UIImageWriteToSavedPhotosAlbum(imageTemp!, nil, nil, nil)
    }
    
    @IBAction func setTimerButton(sender: UIButton) {
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        pictureTakenImageView.image = image
        pictureTakenImageView.contentMode = .ScaleAspectFit
        
        segueToCameraButton.hidden = true
        segueToMemoriesButton.hidden = true
    }
    
    var alert = UIAlertController(
        title: "Set Timer",
        message: "Please set your preferable timer for you lovely story😘, default: 3s",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    var pictureTaken: UIImage?{
        willSet{
            //showPictureView.hidden = false
            //pictureTakenImageView.hidden = false
            //pictureTakenImageView.image = newValue!
            //pictureTakenImageView.contentMode = .ScaleAspectFit
        }
    }
    
    private func initiateAlert(){
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil)
        )
        alert.addAction(UIAlertAction(
            title: "Set",
            style: .Default)
        { (action:UIAlertAction) -> Void in
            if let tf = self.alert.textFields?.first{
                if tf.text != nil{
                    let tfDouble = Double(tf.text!) ?? self.pictureTimer
                    self.pictureTimer = tfDouble
                    print("Timer: \(self.pictureTimer)")
                }else{
                    self.pictureTimer = 3.0
                    print("Alert timer set nil")
                    print("Timer: \(self.pictureTimer)")
                }
            }
            }
        )
        alert.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "seconds"
        }
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
