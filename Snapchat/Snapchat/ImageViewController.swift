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
    
    private struct Storyboard
    {
        static var ShowMyFriends = "Show My Friends"
    }
    
    @IBAction func sendImageToFriend(sender: UIButton) {
        performSegueWithIdentifier(Storyboard.ShowMyFriends, sender: nil)
    }
    
    
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
    
    //MARK: DRAWING STH
    var lastPoint = CGPoint.zero
    var red: CGFloat = 1.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    @IBOutlet weak var tempImageView: UIImageView!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first! as? UITouch {
            //            if drawMode == true{
            //                touch.gestureRecognizers?.first?.enabled = true
            //                touch.view?.userInteractionEnabled = true
            //                lastPoint = touch.locationInView(self.tempImageView)
            //            }else{
            //                touch.view?.userInteractionEnabled = false
            //            }
            lastPoint = touch.locationInView(self.tempImageView)
        }
        
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round )
        //        CGContextSetLineCap(<#T##c: CGContext##CGContext#>, <#T##cap: CGLineCap##CGLineCap#>)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        //        kcgline
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first! as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(pictureTakenImageView.frame.size)
        pictureTakenImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        pictureTakenImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    //    @IBOutlet weak var drawButton: UIButton!
    //
    //    var drawMode: Bool?{
    //        didSet{
    //            if drawMode == true{
    //                self.view.gestureRecognizers?.first?.enabled = true
    //            }else{
    //                self.view.gestureRecognizers?.first?.enabled = false
    //            }
    //        }
    //    }
    //    @IBAction func draw(sender: UIButton) {
    //        drawMode = !drawMode!
    //    }
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func resetDrawing(sender: UIButton) {
        self.pictureTakenImageView.image = image
    }
    
    @IBOutlet weak var textButton: UIButton!
    
    @IBAction func addText(sender: UIButton) {
        presentViewController(textAlert, animated: true, completion: nil)
    }
    
    var pictureText: String?{
        didSet{
            //            if pictureText != ""{
            //
            //            }
            pictureTakenImageView.image = pictureTakenImageView.image?.waterMarkedImage(pictureText!, corner: .TopLeft,
                                                                                        margin: CGPoint(x: 20, y: 20),
                                                                                        waterMarkTextColor: UIColor.redColor(),
                                                                                        waterMarkTextFont: UIFont.systemFontOfSize(45),
                                                                                        backgroundColor: UIColor.clearColor())
        }
    }
    
    var textAlert = UIAlertController(
        title: "Set Text",
        message: "Text will be added on the top right",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    private func initiateTextAlert(){
        textAlert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil)
        )
        textAlert.addAction(UIAlertAction(
            title: "Set",
            style: .Default)
        { (action:UIAlertAction) -> Void in
            if let tf = self.textAlert.textFields?.first{
                if tf.text != nil{
                    self.pictureText = tf.text
                    print("Timer: \(self.pictureText)")
                }else{
                    //                    self.pictureTimer = 3.0
                    print("Text set nil")
                    //                    print("Timer: \(self.pictureText)")
                }
            }
            }
        )
        textAlert.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "your text"
        }
    }
    
    
    
    
    //MARK: OTHER THINGS
    @IBAction func backToCamera(sender: UIButton) {
        print("BACKTO::\(backTo)")
        performSegueWithIdentifier(backTo!, sender: nil)
    }
    @IBOutlet weak var showPictureView: UIView!{
        didSet{
            initiateAlert()
            initiateTextAlert()
        }
    }
    
    @IBAction func savePicture(sender: UIButton) {
        let imageTemp = pictureTakenImageView.image
        //let imageTemp = image                                                                //如果要编辑功能需要改这个变量
        UIImageWriteToSavedPhotosAlbum(imageTemp!, nil, nil, nil)
        var imageObject = ImageObject()
        imageObject.innerImage = pictureTakenImageView.image
        imageObject.timer = pictureTimer
        UsableData.makeSnapFromImage(imageObject)
    }
    
    @IBAction func setTimerButton(sender: UIButton) {
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        pictureTakenImageView.image = image
        pictureTakenImageView.contentMode = .ScaleAspectFill
        tempImageView.contentMode = .ScaleAspectFill
        
        segueToCameraButton.hidden = true
        segueToMemoriesButton.hidden = true
        
        //drawMode = false
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
            textField.placeholder = "Current setting: \(self.pictureTimer) seconds"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowMyFriends {
            if let mvc = segue.destinationViewController.contentViewController as? MyFriendsTableViewController {
                mvc.backTo = backTo
                let tempImageObject = ImageObject()
                tempImageObject.innerImage = self.pictureTakenImageView.image
                tempImageObject.timer = self.pictureTimer
                mvc.message = tempImageObject
            }
        }
    }
    
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image!.CGImage!)
    }
}

extension UIImage{
    
    //水印位置枚举
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20),
                          waterMarkTextColor:UIColor = UIColor.whiteColor(),
                          waterMarkTextFont:UIFont = UIFont.systemFontOfSize(20),
                          backgroundColor:UIColor = UIColor.clearColor()) -> UIImage{
        
        let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                              NSFontAttributeName:waterMarkTextFont,
                              NSBackgroundColorAttributeName:backgroundColor]
        let textSize = NSString(string: waterMarkText).sizeWithAttributes(textAttributes)
        var textFrame = CGRectMake(0, 0, textSize.width, textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        NSString(string: waterMarkText).drawInRect(textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
}
