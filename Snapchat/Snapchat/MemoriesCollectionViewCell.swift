//
//  MemoriesCollectionViewCell.swift
//  Snapchat
//
//  Created by ailina on 16/10/16.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class MemoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showSth: UILabel!
    
    var imageView:UIImageView!
    var selectView:UIView!
    var selectImageView:UIImageView!
    var isSelect = false
    var handleSelect:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame:CGRectZero)
        self.addSubview(self.imageView)
        
        self.selectView = UIView(frame:CGRectZero)
        self.selectView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.addSubview(selectView)
        
        self.selectImageView = UIImageView(frame:CGRectZero)
        self.selectImageView.backgroundColor = mochaColorGreen
        self.selectImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.selectView.addSubview(self.selectImageView)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MemoriesCollectionViewCell.tap(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override func layoutSubviews() {
        self.imageView.frame = self.bounds
        self.selectView.frame = self.bounds
        
        let selectWidth = self.frame.size.width/5
        self.selectImageView.frame = CGRectMake(self.frame.size.width-selectWidth-5, self.frame.size.height-selectWidth-5, selectWidth, selectWidth)
        self.selectImageView.layer.cornerRadius = selectWidth/2
        self.selectImageView.layer.borderWidth = selectWidth/8
    }
    
    func update(image: ImageObject){
        self.imageView.image = image.innerImage 
        self.selectView.hidden = !image.isSelect
        isSelect = !image.isSelect
    }
    
    
    
    func tap(gesture:UITapGestureRecognizer){
        //handleSelect?()
        self.selectView.hidden = !isSelect
        isSelect = !isSelect
        handleSelect?()
    }
}
