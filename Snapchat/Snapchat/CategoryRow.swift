//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class CategoryRow : UITableViewCell, UICollectionViewDataSource {
    
    var selfSegueIdentifier = "Show Stories"
    
    @IBOutlet weak var collectionView: UICollectionView!

    private struct Storyboard
    {
        static var ShowCamera = "Show Camera"
        static var ShowDiscovery = "Show Discovery"
        static var ShowEnforced = "Show Enforced"
    }
    
    var tableIndexSection:Int?
    var storiesArray:[[ImageObject]] = []{
        didSet{
            print("DIDSET!")
            collectionView.reloadData()
        }
    }
    
    private var storiesSelected: [ImageObject]?{
        didSet{
            //performSegueWithIdentifier(Storyboard.ShowEnforced, sender: nil)
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if segue.identifier == Storyboard.ShowEnforced{
//            if let svc = segue.destinationViewController.contentViewController as? ShowEnforcedViewController {
//                svc.backTo = selfSegueIdentifier
//                svc.story = self.storiesSelected
//            }
//        }
//    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("tableViewsection = " + String(tableIndexSection))
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell
        if tableIndexSection == 0{
            if indexPath.row == 0{
                cell.imageView.image = UIImage(named: "snow")
            }else{
                cell.imageView.image = UIImage(named: "mountain")
            }
        }else if tableIndexSection == 3{
            cell.imageView.image = self.storiesArray[indexPath.row].first!.innerImage
        }else{
            cell.imageView.image = UIImage(named: "sunset")
        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tableIndexSection == 3{
            return storiesArray.count
        }else{
            return 15
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(tableIndexSection == 3){
            print("You selected cell #\(indexPath.item)!")
            print("You selected cell Row #\(indexPath.row)!")
            print("You selected cell Section #\(indexPath.section)!")
            self.storiesSelected = storiesArray[indexPath.row]
        }
        
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

