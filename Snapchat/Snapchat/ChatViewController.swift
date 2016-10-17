//
//  ChatViewController.swift
//  Snapchat
//
//  Created by H&H on 2016/10/7.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ChatViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var messageField: UITextField!
    @IBAction func sendPicture(sender: UIButton) {
        showActionSheet()
    }
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    var myID:String{
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    var myName = UsableData.myUsername
    
    var targetRef: FIRDatabaseReference{
        return FIRDatabase.database().reference().child("message").ref
    }
    
//    var synchronizeRef: FIRDatabaseReference{
//        let target = FIRDatabase.database().reference().child("users").child(myID).child("friends").valueForKey(self.navigationItem.title!) as! String
//        return FIRDatabase.database().reference().child("users").child(target).child("message").child(myID).ref
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.editable = false
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGuesture.cancelsTouchesInView = false
        content.addGestureRecognizer(tapGuesture)
        
        messageField.delegate = self
        messageField.returnKeyType = UIReturnKeyType.Send
        
        targetRef.observeEventType(FIRDataEventType.ChildAdded) { (snapShot: FIRDataSnapshot) in
            let value = snapShot.value as? NSDictionary
            switch(value?.valueForKey("type") as! String){
            case "text":
                if let message = value?.valueForKey("content") as? String{
                    let sender = value?.valueForKey("sender") as! String
                    switch(sender){
                    case self.myName:
                        self.insertString("Me:")
                        self.insertString(message)
                    default:
                        self.insertString(sender+":")
                        self.insertString(message)
                    }
                    
                }
            case "image":
                if let imageURL = value?.valueForKey("content") as? String{
                    FIRStorage.storage().referenceForURL(imageURL).dataWithMaxSize(10*1024*1024, completion: { (data, error) in
                        if (error != nil) {
                            print("ERROR: \(error)")
                        } else {
                            let sender = value?.valueForKey("sender") as! String
                            let image: UIImage! = UIImage(data: data!)
                            switch(sender){
                            case self.myName:
                                self.insertString("Me:")
                                self.insertPicture(self.convert(image))
                            default:
                                self.insertString(sender+":")
                                self.insertPicture(self.convert(image))
                            }
                        }
                    })
                }
            default:
                break
            }
        }
        
    }
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: "PHOTO SOURCE", message: nil, preferredStyle: .ActionSheet)
        
        //photo source - camera
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .Default, handler: { alertAction in
            self.showImagePickerForSourceType(.Camera)
        }))
        
        //photo source - photo library
        actionSheet.addAction(UIAlertAction(title: "PHOTO LIBRARY", style: .Default, handler: { alertAction in
            self.showImagePickerForSourceType(.PhotoLibrary)
        }))
        
        //cancel button
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .Cancel, handler:nil))
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        dispatch_async(dispatch_get_main_queue(), {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .CurrentContext
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        })
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                //let converted = self.convert(image)
                //self.insertPicture(converted)
                self.pushImage(image)
            }
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        pushMessage(textField.text!)
        //insertString(textField.text!)
        textField.text?.removeAll()
        textField.resignFirstResponder()
        return true
    }
    
    // inset text and image
    
    func pushMessage(message: String){
        let messageContent = ["type":"text","sender":self.myName,"content":message]
        targetRef.childByAutoId().setValue(messageContent)
        //synchronizeRef.childByAutoId().setValue(messageContent)
    }
    
    func pushImage(image: UIImage){
        let data: NSData = UIImageJPEGRepresentation(image, 0.5)!
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.stringFromDate(today)
        let storageRef = FIRStorage.storage().referenceForURL("gs://snapchat-35d64.appspot.com").child(date)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if (error != nil) {
            } else {
                if let url = metadata!.downloadURL()?.absoluteString {
                    let messageContent = ["type":"image","sender":self.myName,"content":url]
                    self.targetRef.childByAutoId().setValue(messageContent)
                    //self.synchronizeRef.childByAutoId().setValue(messageContent)
                }
            }
        }
    }
    
    func insertString(text:String){
        let namedText = "\(text)\n"
        let mutableStr = NSMutableAttributedString(attributedString: content.attributedText)
        let selectedRange = content.selectedRange
        let attStr = NSAttributedString(string: namedText)
        mutableStr.insertAttributedString(attStr, atIndex: selectedRange.location)
        let newSelectedRange = NSMakeRange(selectedRange.location+attStr.length, 0)
        content.attributedText = mutableStr
        content.selectedRange = newSelectedRange
        self.content.scrollRangeToVisible(newSelectedRange)
    }
    
    func insertPicture(imgAttachmentString: NSAttributedString){
        let mutableStr = NSMutableAttributedString(attributedString: content.attributedText)
        let selectedRange = content.selectedRange
        mutableStr.insertAttributedString(imgAttachmentString, atIndex: selectedRange.location)
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        content.attributedText = mutableStr
        content.selectedRange = newSelectedRange
        self.content.scrollRangeToVisible(newSelectedRange)
    }
    
    func convert(image: UIImage) -> NSAttributedString{
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        let imageWidth = self.content.frame.width - 10
        let imageHeight = image.size.height/image.size.width*imageWidth
        imgAttachment.bounds = CGRectMake(0, 0, imageWidth, imageHeight)
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        return imgAttachmentString
    }
    
    // keyboard animation
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardHeight = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
            
            UIView.animateWithDuration(0.5, animations: {
                self.bottom.constant = keyboardHeight
                }, completion: { (completed) in
                    if completed {
                        self.content.scrollRangeToVisible(NSMakeRange(self.content.text.characters.count-1, 0))
                    }
                    
            })
            
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        UIView.animateWithDuration(0.5, animations: {
            self.bottom.constant = 8
        })
        
    }
    
    func dismissKeyboard(sender:UITapGestureRecognizer) {
        messageField.resignFirstResponder()
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
