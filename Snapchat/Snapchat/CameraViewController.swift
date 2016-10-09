//
//  CameraViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/1.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import AVFoundation

//class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
class CameraViewController: UIViewController {
    
    var pictureTimer: NSTimeInterval = 3.0
    var selfSegueIdentifier = "Show Camera"
    
    @IBOutlet weak var segueToShowPictureButton: UIButton!
    private struct Storyboard
    {
        static var ShowStories = "Show Stories"
        static var ShowMemories = "Show Memories"
        static var ShowChat = "Show Chat"
        static var ShowPersonal = "Show Personal"
        static var ShowPicture = "Show Picture"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let changePageLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToStories))
        changePageLeftSwipe.direction = .Left
        cameraContainer.addGestureRecognizer(changePageLeftSwipe)
        
        let changePageRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToChat))
        changePageRightSwipe.direction = .Right
        cameraContainer.addGestureRecognizer(changePageRightSwipe)
        
        let changePageUpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToMemories))
        changePageUpSwipe.direction = .Up
        cameraContainer.addGestureRecognizer(changePageUpSwipe)
        
        let changePageDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.goToPersonal))
        changePageDownSwipe.direction = .Down
        cameraContainer.addGestureRecognizer(changePageDownSwipe)
        
        segueToShowPictureButton.hidden = true
        initiateCamera()
        
    }
    
    
    var pictureTaken: UIImage?{
        didSet{
            performSegueWithIdentifier(Storyboard.ShowPicture, sender: nil)
        }
    }
    
    //MARK: Camera
    var cameraDirection = AVCaptureDevicePosition.Back
    var flashOption = AVCaptureFlashMode.Off
    
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    //var previewLayer: AVCaptureVideoPreviewLayer?
    var error: NSError?
    var captureDevice: AVCaptureDevice?
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if(device.position == position){
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    @IBAction func cameraFlashOptionButton(sender: UIButton) {
        
        if sender.currentTitle == "FlashClosed"{
            sender.setTitle("FlashOpened", forState: UIControlState.Normal)
            flashOption = AVCaptureFlashMode.On
        }else{
            sender.setTitle("FlashClosed", forState: UIControlState.Normal)
            flashOption = AVCaptureFlashMode.Off
        }
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                device.flashMode = flashOption
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func cameraDirectionButton(sender: UIButton) {
        if sender.currentTitle == "Back"{
            sender.setTitle("Front", forState: UIControlState.Normal)
            cameraDirection = AVCaptureDevicePosition.Front
        }else{
            sender.setTitle("Back", forState: UIControlState.Normal)
            cameraDirection = AVCaptureDevicePosition.Back
        }
        
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice?
        newCamera = self.cameraWithPosition(cameraDirection)
        var newVideoInput: AVCaptureDeviceInput?
        do {
            try newVideoInput = AVCaptureDeviceInput(device: newCamera!)
        } catch let error {
            print("\(error)")
        }
        if(newVideoInput != nil) {
            captureSession.addInput(newVideoInput)
        } else {
            print("Error creating capture device input")
        }
        
        captureSession.commitConfiguration()
        captureDevice! = newCamera!
        
    }
    
    @IBOutlet weak var cameraContainer: UIView!
    
    private func initiateCamera(){
        
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == cameraDirection }
        captureDevice = devices.first as? AVCaptureDevice
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("WTF????")
        }
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.bounds = view.bounds
        previewLayer?.position = CGPointMake(view.bounds.midX, view.bounds.midY)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        let cameraPreview = UIView(frame: CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height))
        cameraPreview.layer.addSublayer(previewLayer!)
        previewLayer!.position = CGPointMake(view.bounds.midX, view.bounds.midY)
        view.insertSubview(cameraPreview, belowSubview: cameraContainer)
        
    }
    
    @IBAction func takePhotoButton(sender: UIButton) {
        if let videoConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.pictureTaken = UIImage(data: imageData)
            }
        }
    }
    
    //MARK: Segue
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
        //self.saveToCamera()
        if segue.identifier == Storyboard.ShowPicture {
            if let pvc = segue.destinationViewController.contentViewController as? ImageViewController {
                pvc.backTo = selfSegueIdentifier
                pvc.image = self.pictureTaken
            }
        }
    }
    
}



/*
 extension UIImage {
 /**
 *  重设图片大小
 */
 func reSizeImage(reSize:CGSize)->UIImage {
 //UIGraphicsBeginImageContext(reSize);
 UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.mainScreen().scale);
 self.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
 let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
 UIGraphicsEndImageContext();
 return reSizeImage;
 }
 
 /**
 *  等比率缩放
 */
 func scaleImage(scaleSize:CGFloat)->UIImage {
 let reSize = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize)
 return reSizeImage(reSize)
 }
 }
 */

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

/*
 extension UIImage {
 convenience init(view: UIView) {
 UIGraphicsBeginImageContext(view.frame.size)
 view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
 let image = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 self.init(CGImage: image!.CGImage!)
 }
 }
 */
