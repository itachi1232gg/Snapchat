//
//  AddFromAddressBookViewController.swift
//  Snapchat
//
//  Created by ailina on 16/10/15.
//  Copyright © 2016年 Can. All rights reserved.
//

//import UIKit
//import AddressBookUI
//
//class AddFromAddressBookViewController: UIViewController ,ABPeoplePickerNavigationControllerDelegate{
//    
//    //@IBOutlet weak var segueToChat: UIButton!
//    private struct Storyboard
//    {
//        static var ShowStories = "Show Stories"
//        static var ShowMemories = "Show Memories"
//        static var ShowChat = "Show Chat"
//        static var ShowPersonal = "Show Personal"
//        static var ShowPicture = "Show Picture"
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        //弹出通讯录联系人选择界面
//        let picker = ABPeoplePickerNavigationController()
//        picker.peoplePickerDelegate = self
//        self.presentViewController(picker, animated: true) { () -> Void in
//            
//        }
//        //segueToChat.hidden = true
//    }
//    
//    func didTouchUpInsidePickButton(item: UIBarButtonItem) {
//        let picker = ABPeoplePickerNavigationController()
//        picker.peoplePickerDelegate = self
//        
//        if #available(iOS 8.0, *) {
//            picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        presentViewController(picker, animated: true, completion: nil)
//    }
//    
//    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord!) {
//        
//        //        //获取姓
//        //        var lastName = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String?
//        //        print("姓:\(lastName)")
//        //        //获取名
//        //        var firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String?
//        //        print("名:\(firstName)")
//        //获取姓
//        
//        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as! String?
//        print("选中人的姓：\(lastName)")
//        
//        //获取名
//        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as! String?
//        print("选中人的名：\(firstName)")
//        /*
//         //获取电话
//         let phoneValues:ABMutableMultiValueRef? = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
//         if phoneValues != nil {
//         print("选中人电话：")
//         /*
//         for i in 0 ..< ABMultiValueGetCount(phoneValues){
//         
//         // 获得标签名
//         let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
//         as CFStringRef;
//         // 转为本地标签名（能看得懂的标签名，比如work、home）
//         let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
//         .takeRetainedValue() as! String
//         
//         let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
//         let phone = value.takeRetainedValue() as! String
//         print("\(localizedPhoneLabel):\(phone)")
//         }
//         */
//         }*/
//        //performSegueWithIdentifier(Storyboard.ShowStories, sender: nil)
//        print("Selected!!!")
//    }
//    
//    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,
//                                          didSelectPerson person: ABRecord!, property: ABPropertyID,
//                                                          identifier: ABMultiValueIdentifier) {
//        print("Select 1")
//        
//    }
//    
//    //取消按钮点击
//    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
//        //去除地址选择界面
//        print("Select 2")
//        peoplePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
//            
//        })
//    }
//    
//    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,
//                                          shouldContinueAfterSelectingPerson person: ABRecord!) -> Bool {
//        //        self.dismissViewControllerAnimated(true) {
//        //            print("====================")
//        //
//        //            let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as! String?
//        //
//        //            print(lastName)
//        //
//        //            print("====================")
//        print("Select 3")
//        //        }
//        return true
//    }
//    
//    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,
//                                          shouldContinueAfterSelectingPerson person: ABRecord!, property: ABPropertyID,
//                                                                             identifier: ABMultiValueIdentifier) -> Bool {
//        print("Select 4")
//        return true
//    }
//}

import UIKit
import Contacts
import ContactsUI

class AddFromAddressBookViewController: UIViewController,CNContactPickerDelegate,CNContactViewControllerDelegate {

        private var addressBookStore: CNContactStore!
        private var menuArray: NSMutableArray?
        let picker = CNContactPickerViewController()

        override func viewDidLoad() {
            super.viewDidLoad()
            addressBookStore = CNContactStore()
            checkContactsAccess();
            // Do any additional setup after loading the view, typically from a nib.
        }

        private func checkContactsAccess() {
            switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
            // Update our UI if the user has granted access to their Contacts
            case .Authorized:
                self.showContactsPicker()

            // Prompt the user for access to Contacts if there is no definitive answer
            case .NotDetermined :
                self.requestContactsAccess()

            // Display a message if the user has denied or restricted access to Contacts
            case .Denied,
                 .Restricted:
                let alert = UIAlertController(title: "Privacy Warning!",
                                              message: "Please Enable permission! in settings!.",
                                              preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }

        private func requestContactsAccess() {

            addressBookStore.requestAccessForEntityType(.Contacts) {granted, error in
                if granted {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showContactsPicker()
                        return
                    }
                }
            }
        }


        //Show Contact Picker
        private  func showContactsPicker() {

            picker.delegate = self
            self.presentViewController(picker , animated: true, completion: nil)
            print("showing")

        }


        //    optional public func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact)

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


}
