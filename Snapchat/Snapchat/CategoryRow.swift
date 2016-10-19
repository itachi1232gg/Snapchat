//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryRow : UITableViewCell {
    
    var upperView:StoriesViewController?
//    var selectedCellID: String?

    
    
    
    typealias  typeStory = DiscoverData.Entry
    var storyList = [typeStory]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var tableIndexSection:Int?
    var selectedSection:Int?
    
    private func fetchImage(imageURL: NSURL?) -> UIImage?{
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url){
                let image = UIImage(data: imageData)
                return image
            }
        }
        return nil
    }
    
}

extension CategoryRow : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if tableIndexSection == 0 {
            return storyList.count
        }
        
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //upperView.performSegueWithIdentifier("idt2", sender: nil)
//        selectedSection = indexPath.row
//        print(selectedSection)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell
//        print("selectedCellID=   \(selectedCellID)")
        upperView!.selectedCellID = cell.cellID
        upperView!.view.setNeedsDisplay()
        upperView!.performSegueWithIdentifier("idt2", sender: upperView)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //        print ("index-section = " + String(indexPath.section))
        //        print ("index-row = " + String(indexPath.row))
        print ("tableViewsection = " + String(tableIndexSection))
        //        print ("==========================")
        

        print("count2 = \(self.storyList.count)")

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell
        
        if tableIndexSection == 0 {

            let entry = storyList[indexPath.row]
            print("entrycount= \(storyList.count)")
            print(String(entry.filename))
            let imageURL = NSURL(string: entry.filename)
            if let image = fetchImage(imageURL) {
                cell.imageView.image = image
            }
            cell.storyTitle.text = entry.heading
            cell.storyContent.text = entry.content
            print(entry.content)
            cell.cellID = entry.discoverID
            
        }else if tableIndexSection == 1{
            cell.imageView.image = UIImage(named: "sunset")
        }else {
            cell.imageView.image = UIImage(named: "bridge")

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
