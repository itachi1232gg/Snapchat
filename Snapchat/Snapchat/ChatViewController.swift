//
//  ChatViewController.swift
//  Snapchat
//
//  Created by H&H on 2016/10/7.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var messageField: UITextField!
    @IBAction func sendPicture(sender: UIButton) {
        showActionSheet()
    }

    @IBOutlet weak var bottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.editable = false
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGuesture.cancelsTouchesInView = false
        content.addGestureRecognizer(tapGuesture)
        
        messageField.delegate = self
        messageField.returnKeyType = UIReturnKeyType.Send
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
                self.insertPicture(image)
            }
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        insertString(textField.text!)
        textField.text?.removeAll()
        textField.resignFirstResponder()
        return true
    }
    
    // inset text and image
    func insertString(text:String){
        let namedText = "ME: \(text)\n"
        let mutableStr = NSMutableAttributedString(attributedString: content.attributedText)
        let selectedRange = content.selectedRange
        let attStr = NSAttributedString(string: namedText)
        mutableStr.insertAttributedString(attStr, atIndex: selectedRange.location)
        let newSelectedRange = NSMakeRange(selectedRange.location+attStr.length, 0)
        content.attributedText = mutableStr
        content.selectedRange = newSelectedRange
        self.content.scrollRangeToVisible(newSelectedRange)
    }
    
    func insertPicture(image: UIImage){
        insertString("")
        let mutableStr = NSMutableAttributedString(attributedString: content.attributedText)
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        let imageWidth = content.frame.width - 10
        let imageHeight = image.size.height/image.size.width*imageWidth
        imgAttachment.bounds = CGRectMake(0, 0, imageWidth, imageHeight)
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        let selectedRange = content.selectedRange
        mutableStr.insertAttributedString(imgAttachmentString, atIndex: selectedRange.location)
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        content.attributedText = mutableStr
        content.selectedRange = newSelectedRange
        self.content.scrollRangeToVisible(newSelectedRange)
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
