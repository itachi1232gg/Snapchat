//
//  MemoriesViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class MemoriesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var selfSegueIdentifier = "Show Memories"
    @IBOutlet weak var segueToShowPicture: UIButton!
    
    @IBAction func memoriesSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            snapView.hidden = false
            //showPictureView.hidden = true
            //pictureTakenImageView.hidden = true
        case 1:
            break
        case 2:
            snapView.hidden = true
            //showPictureView.hidden = false
            //pictureTakenImageView.hidden = false
            initiatePhotoLibrary()
        default:
            break
        }
    }

    @IBOutlet weak var snapView: UIView!
    
    private var pictureTaken: UIImage?{
        didSet{
            performSegueWithIdentifier(Storyboard.ShowPicture, sender: nil)
        }
    }
    
    private struct Storyboard
    {
        static var ShowCamara = "Show Camera"
        static var ShowPicture = "Show Picture"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let changePageDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MemoriesViewController.goToCamara))
        changePageDownSwipe.direction = .Down
        self.view.addGestureRecognizer(changePageDownSwipe)
        // Do any additional setup after loading the view.
        
        segueToShowPicture.hidden = true
        
        //showPictureView.hidden = true
        //pictureTakenImageView.hidden = true
        
    }
    
    //在你需要的地方调用就可以用了
    //记得上面要改class MemoriesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func initiatePhotoLibrary(){
        dispatch_async(dispatch_get_main_queue(), {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .CurrentContext
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true) {
            
            print("media type: \(info[UIImagePickerControllerMediaType])")
            
            //选好的照片就是下面的image，然后在if里面想干啥就干啥
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                //self.pictureTakenImageView.image = image
                //self.pictureTakenImageView.contentMode = .ScaleAspectFit
                self.pictureTaken = image
            }
        }
    }

    
    
    func goToCamara()
    {
        performSegueWithIdentifier(Storyboard.ShowCamara, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowPicture {
            if let pvc = segue.destinationViewController.contentViewController as? ImageViewController {
                pvc.backTo = selfSegueIdentifier
                pvc.image = self.pictureTaken
            }
        }
    }

}
