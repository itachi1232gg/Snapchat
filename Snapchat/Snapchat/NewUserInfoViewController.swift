//
//  NewUserInfoViewController.swift
//  Snapchat
//
//  Created by 灿 崔 on 17/10/16.
//  Copyright © 2016 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase
import  FirebaseAuth

class NewUserInfoViewController: UIViewController {
    
    
    @IBOutlet weak var firstnameField: UITextField!

    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var mobileField: UITextField!
    
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    
    @IBAction func start(sender: UIButton) {
        print("print button**************************")
        
        
        if !(firstnameField.text?.isEmpty)! && !(lastnameField.text?.isEmpty)!  && !(usernameField.text?.isEmpty)! && !(mobileField.text?.isEmpty)! {
            
            print("print button1")
            
            
            let userMsg = [
                "username": usernameField.text!,
                "firstname": firstnameField.text!,
                "lastname": lastnameField.text!,
                "mobilenumber": mobileField.text!
            ]
            if let  uid = FIRAuth.auth()?.currentUser?.uid{
                pushToDataBase(userMsg,uid: uid)
                performSegueWithIdentifier("start", sender: self)
                
            }else {
                
                print("print button2")
                
                
                let alert = UIAlertController(title: "Alert", message: "Please finish your user information", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                //                let alert = UIAlertView()
                //                alert.title = "Error"
                //                alert.message = "Cannot get uid"
                //                alert.addButtonWithTitle("OK")
                //                alert.show()
            }
            
            
        }else {
            print("print button3")
            
            let alert = UIAlertController(title: "Alert", message: "Please finish your user information", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
    //    @IBAction func btn_start(sender: UIButton) {
    //
    //        print("print button")
    //
    //
    //        if firstnameField.text != "" && lastnameField.text != "" && usernameField.text != "" && mobileField != ""{
    //
    //            print("print button1")
    //
    //
    //            let userMsg = [
    //                "username": usernameField.text!,
    //                "firstname": firstnameField.text!,
    //                "lastname": lastnameField.text!,
    //                "mobilenumber": mobileField.text!
    //            ]
    //            if let  uid = FIRAuth.auth()?.currentUser?.uid{
    //                pushToDataBase(userMsg,uid: uid)
    //                performSegueWithIdentifier("start", sender: self)
    //
    //            }else {
    //
    //                print("print button2")
    //
    //
    //                let alert = UIAlertController(title: "Alert", message: "Please finish your user information", preferredStyle: UIAlertControllerStyle.Alert)
    //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    //                self.presentViewController(alert, animated: true, completion: nil)
    //
    ////                let alert = UIAlertView()
    ////                alert.title = "Error"
    ////                alert.message = "Cannot get uid"
    ////                alert.addButtonWithTitle("OK")
    ////                alert.show()
    //            }
    //
    //
    //        }else {
    //            print("print button3")
    //
    //            let alert = UIAlertController(title: "Alert", message: "Please finish your user information", preferredStyle: UIAlertControllerStyle.Alert)
    //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    //            self.presentViewController(alert, animated: true, completion: nil)
    //        }
    //    }
    
    func pushToDataBase(userMsg: [String:String], uid: String){
        
        mainRef.child("users").child(uid).setValue(userMsg)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
