//
//  DisplayViewController.swift
//  Snapchat
//
//  Created by 灿 崔 on 18/10/16.
//  Copyright © 2016 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DisplayViewController: UIViewController {
    
    
    var storyID: String?
    var image:String?
    
    var ref: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    
    @IBOutlet weak var displayIV: UIImageView!
    @IBOutlet weak var displaytitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if storyID != nil  {
            displaytitle.text = storyID!
            print(storyID!)
            getDiscoverListData()
            print(image)

        }

        

        

        // Do any additional setup after loading the view.
    }
    
    private func fetchImage(imageURL: NSURL?) -> UIImage?{
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url){
                let image = UIImage(data: imageData)
                return image
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDiscoverListData() {
        
        //let userID = FIRAuth.auth()?.currentUser?.uid
        //        ref.observe(FIRDataEventType.value, with: { (snapshot) in
        //            let postDict = snapshot.value as! [String : AnyObject]
        //            // ...
        //        })
        
        ref.child("discoverlist").child(storyID!).observeEventType(FIRDataEventType.Value, withBlock: { (snapShot:FIRDataSnapshot) in
            
            let internalDatausers = (snapShot.value as? NSDictionary)!
            self.image = internalDatausers.valueForKey("image") as? String
            
            self.displayIV.image = self.fetchImage(NSURL(string: self.image!))
            
        })
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
