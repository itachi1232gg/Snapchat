//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class CategoryRow : UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var tableIndexSection:Int?
}

extension CategoryRow : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        print ("index-section = " + String(indexPath.section))
//        print ("index-row = " + String(indexPath.row))
          print ("tableViewsection = " + String(tableIndexSection))
//        print ("==========================")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell

        if tableIndexSection == 0 {
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "snow")
            } else {
                cell.imageView.image = UIImage(named: "mountain")
            }
        }else {
            cell.imageView.image = UIImage(named: "sunset")
        }
        
        return cell
    }
    
}

extension CategoryRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
