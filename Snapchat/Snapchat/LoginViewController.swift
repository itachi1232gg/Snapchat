//
//  LoginViewController.swift
//  Snapchat
//
//  Created by 灿 崔 on 17/10/16.
//  Copyright © 2016 Can. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    //button forget your password
    @IBAction func btn_fogetpswd(sender: UIButton) {
    }
    //button log in
    @IBAction func btn_login(sender: UIButton) {
        
        if let userName = username.text  {
            if password.text != nil{
                
                FIRAuth.auth()?.signInWithEmail(userName, password: password.text! as String, completion: { (user, error) in
                    if let error = error {
                        print(String(error))
                    }else{
                        print(userName, "log in successful!")
                        self.performSegueWithIdentifier("loginsuccess", sender: nil)
                        let myUserID = FIRAuth.auth()?.currentUser?.uid
                        print("my userId: \(myUserID)")
                        self.getMyUsername()
                    }
                })
                
            }
        }
        
        
        
    }
    
    func getMyUsername(){
        var name: String = ""
        UsableData.selfRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let me = snapShot.value as? NSDictionary{
                name = me["username"] as! String
                //            myUsername = name
                print("myName is: \(name)")
                UsableData.myUsername = name
            }
        }
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
