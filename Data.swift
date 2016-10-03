//
//  Data.swift
//  Snapchat
//
//  Created by 灿 崔 on 4/10/2016.
//  Copyright © 2016 Can. All rights reserved.
//

import Foundation


class Data {
    class Entry {
        let filename : String
        let heading : String
        init(fname : String, heading : String) {
            self.heading = heading
            self.filename = fname
        }
    }
    
    let places = [
        Entry(fname: "bridge", heading: "Heading 1"),
        Entry(fname: "mountain", heading: "Heading 2"),
        Entry(fname: "snow", heading: "Heading 3"),
        Entry(fname: "sunset", heading: "Heading 4")
    ]
    
}
