//
//  Data.swift
//  Snapchat
//
//  Created by 灿 崔 on 4/10/2016.
//  Copyright © 2016 Can. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DiscoverData {
    
    
    class Entry {
        let filename : String
        let heading : String
        let content :String
        let discoverID : String
        init(fname : String, heading : String, content: String, discoverID: String) {
            self.heading = heading
            self.filename = fname
            self.content = content
            self.discoverID = discoverID
        }
    }
    
    
    
}
