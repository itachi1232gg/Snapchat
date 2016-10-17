//
//  SignupViewController.swift
//  Snapchat
//
//  Created by 灿 崔 on 17/10/16.
//  Copyright © 2016 Can. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class SignupViewController: UIViewController {
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func btn_signup(sender: UIButton) {
        if emailField.text != nil {
            if passwordField.text != nil {
                FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: { (user, error) in
                    if let error = error {
                        print(String(error))
                    }else{
                        print(String(user), "singed up")
                        self.performSegueWithIdentifier("signup", sender: nil)
                        
                    }
                })
            }
        }
        
    }
    
    func login(email: String, password: String) {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
