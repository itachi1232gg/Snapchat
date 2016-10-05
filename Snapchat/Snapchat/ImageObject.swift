//
//  ImageObject.swift
//  Snapchat
//
//  Created by ailina on 16/10/4.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import AssetsLibrary

class ImageObject: NSObject {
    
    var asset: ALAsset!
    var innerImage: UIImage!
    var isSelect:Bool = false
    override init() {
        super.init()
    }
    
}
