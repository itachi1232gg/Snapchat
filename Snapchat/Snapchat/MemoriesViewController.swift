//
//  MemoriesViewController.swift
//  Snapchat
//
//  Created by ailina on 16/9/30.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MemoriesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var imageArray:[ImageObject] = []{//在initImageArray里设置提取信息
        didSet{
            memoriesCollectionView.reloadData()
        }
    }
    var storiesArray:[[ImageObject]] = []{
        didSet{
            memoriesCollectionView.reloadData()
        }
    }
    
    private var selfSegueIdentifier = "Show Memories"
    @IBOutlet weak var segueToShowPicture: UIButton!
    
    @IBOutlet weak var segueToShowEnforced: UIButton!
    
    //MARK: Init of CollectionView
    @IBOutlet weak var memoriesCollectionView: UICollectionView!
    let reuseIdentifier = "memoriesCell" // also enter this string as the cell identifier in the storyboard
    var count:Int = 0;
    var selectedImage:[ImageObject] = []
    var selectedStories:[[ImageObject]] = []
    var tempImageObject: ImageObject!
    var selectMode: Bool?{
        didSet{
            if selectMode! == true{
                self.title = "Please choose picture"
                selectButton.setTitle("selecting", forState: UIControlState.Normal)
                cancelButton.enabled = true
            }else{
                self.title = "Memories"
                selectButton.setTitle("select", forState: UIControlState.Normal)
                cancelButton.enabled = false
                makeStoryButton.enabled = false
                deleteButton.enabled = false
            }
            initImageArray()
            //            memoriesCollectionView.reloadData()
            //print("selectMode: \(selectMode)")
        }
    }
    
    @IBOutlet weak var makeStoryButton: UIBarButtonItem!
    //将所选图片变成story
    //var selectedImage:[ImageObject] = [] 直接调用得到所选图片信息
    @IBAction func makeStory(sender: UIBarButtonItem) {
        /*************************************************************************************************/
        /*************************************************************************************************/
        selectedImage=[]
        for  item in imageArray{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        UsableData.makeStoriesFromSelectedSnaps(selectedImage)
        /*************************************************************************************************/
        /*************************************************************************************************/
        /*************************************************************************************************/
        
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    //删除所选图片
    //var selectedImage:[ImageObject] = [] 直接调用得到所选图片信息
    @IBAction func deleteSelectedPicture(sender: UIBarButtonItem) {
        /*************************************************************************************************/
        /*************************************************************************************************/
        selectedImage=[]
        for  item in imageArray{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        UsableData.deleteSelectedSnaps(selectedImage)
        
        /*************************************************************************************************/
        /*************************************************************************************************/
        /*************************************************************************************************/
    }
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancelMakeStory(sender: UIBarButtonItem) {
        selectMode = false
    }
    
    @IBOutlet weak var selectButton: UIButton!
    @IBAction func selectSwitch(sender: UIButton) {
        selectMode = !selectMode!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let changePageDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MemoriesViewController.goToCamara))
        changePageDownSwipe.direction = .Down
        self.view.addGestureRecognizer(changePageDownSwipe)
        // Do any additional setup after loading the view.
        
        segueToShowPicture.hidden = true
        segueToShowEnforced.hidden = true
        
        selectMode = false
        initCollectionView()
        //        initImageArray()
        //        print("Index:  \(self.memoriesSegmentedButton.selectedSegmentIndex)")
        self.memoriesSegmentedButton.selectedSegmentIndex = 0
        //        print("Index:  \(self.memoriesSegmentedButton.selectedSegmentIndex)")
        
    }
    
    
    //MARK: COLLECTION VIEW
    func initImageArray(){
        let index = memoriesSegmentedButton.selectedSegmentIndex
        self.count = 0
        self.imageArray = []
        self.storiesArray = []
        if index == 1{//读取stories的信息
            //            self.storiesArray = UsableData.readStories()
            readStories()
        }else{//读取snaps的信息
            //            self.imageArray = UsableData.readSnaps()
            readSnaps()
        }
    }
    
    func readStories(){
        //self.lastkey = nil
        UsableData.myStoriesRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let myStories = snapShot.value as? NSDictionary{
                for key in myStories.allKeys {
                    let storiesId = key as! String
                    //if(self.lastkey == nil || (self.lastkey != nil && self.lastkey! == storiesId)){
                    var tempArray: [ImageObject] = []
                    if let snaps = myStories[storiesId]!["snaps"] as? NSDictionary{
                        for snapKey in snaps.allKeys{
                            let snapId = snapKey as! String
                            var tempImageObject = ImageObject()
                            let urlString = snaps[snapId]!["url"] as! String
                            let url = NSURL(string: urlString)
                            let timerString = snaps[snapId]!["timer"]! as! String
                            let timer = Double(timerString)
                            print("readSnapsURL:\(urlString), timer:\(timerString)")
                            
                            var image:UIImage?
                            let gsReference = storage.referenceForURL(url!.absoluteString!)
                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                            gsReference.dataWithMaxSize(10 * 1024 * 1024) { (data, error) -> Void in
                                if (error != nil) {
                                    print("ERROR: \(error)")
                                } else {
                                    // Data for "images/island.jpg" is returned
                                    image = UIImage(data: data!)
                                    tempImageObject.innerImage = image
                                    tempImageObject.isSelect = false
                                    tempImageObject.timer = timer
                                    
                                    self.memoriesCollectionView.reloadData()
                                }
                            }
                            tempArray.append(tempImageObject)
                        }
                        
                        //self.lastkey = storiesId
                        self.storiesArray.append(tempArray)
                    }
                    
                    //}
                }
            }
        }
        
    }
    
    var lastkey: String?
    
    func readSnaps(){
        self.lastkey = nil
        UsableData.mySnapsRef.observeSingleEventOfType(.Value){ (snapShot: FIRDataSnapshot) in
            if let mySnaps = snapShot.value as? NSDictionary{
                var tempImageArray: [ImageObject] = []
                for key in mySnaps.allKeys{
                    
                    print("snapKey:\(key)")
                    let snapId = key as! String
                    //if(self.lastkey == nil || (self.lastkey != nil && self.lastkey! == snapId)){
                    //                    for value in mySnaps.allValues {
                    let urlString = mySnaps[snapId]!["url"] as! String
                    let url = NSURL(string: urlString)
                    let timerString = mySnaps[snapId]!["timer"]! as! String
                    let timer = Double(timerString)
                    print("readSnapsURL:\(urlString), timer:\(timerString)")
                    var tempImageObject = ImageObject()
                    
                    var image:UIImage?
                    let gsReference = storage.referenceForURL(url!.absoluteString!)
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    gsReference.dataWithMaxSize(10 * 1024 * 1024) { (data, error) -> Void in
                        if (error != nil) {
                            print("ERROR: \(error)")
                        } else {
                            // Data for "images/island.jpg" is returned
                            image = UIImage(data: data!)
                            print("?")
                            tempImageObject.innerImage = image
                            tempImageObject.timer = timer
                            tempImageObject.isSelect = false
                            tempImageObject.imageId = snapId
                            tempImageObject.url = url
                            self.imageArray.append(tempImageObject)
                        }
                    }
                    //}
                    
                    
                    
                    //                    tempImageArray.append(tempImageObject)
                    //                    }
                }
                //                self.imageArray = tempImageArray
            }
        }
        
    }
    
    //    func fetchImageFromDB(url: NSURL) -> UIImage?{
    //
    //        return image
    //    }
    
    func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        let itemWidth = SCREEN_WIDTH/4 - 6
        let itemHeight: CGFloat = 100.0
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 2 //上下间隔
        flowLayout.minimumInteritemSpacing = 2 //左右间隔
        
        
        self.memoriesCollectionView.collectionViewLayout = flowLayout
        self.memoriesCollectionView.backgroundColor = UIColor.clearColor()
        //注册
        self.memoriesCollectionView.registerClass(MemoriesCollectionViewCell.self,forCellWithReuseIdentifier:reuseIdentifier)
        //设置代理
        self.memoriesCollectionView.delegate = self
        self.memoriesCollectionView.dataSource = self
    }
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.items.count
        let index = memoriesSegmentedButton.selectedSegmentIndex
        if index == 1{
            return self.storiesArray.count
        }else{
            return self.imageArray.count
        }
        
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath:indexPath) as! MemoriesCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //print("\(self.items[indexPath.item])")
        //cell.showSth.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.cyanColor() // make cell more visible in our example project
        
        if selectMode == false{
            cell.gestureRecognizers?.first?.enabled = false
        }else{
            cell.gestureRecognizers?.first?.enabled = true
        }
        
        let index = memoriesSegmentedButton.selectedSegmentIndex
        if index == 1{
            cell.update(storiesArray[indexPath.row].first!)
        }else{
            cell.update(imageArray[indexPath.row])
        }
        
        cell.handleSelect={
            if cell.isSelect{
                if self.count > 0{
                    self.count -= 1
                }
                self.imageArray[indexPath.row].isSelect = false
                
            }else{
                self.count += 1
                self.imageArray[indexPath.row].isSelect = true
            }
            
            if(self.count > 0){
                self.title = "Choose \(self.count) pictures"
                self.makeStoryButton.enabled = true
                self.deleteButton.enabled = true
            }else{
                self.title = "Please choose picture"
                self.makeStoryButton.enabled = false
                self.deleteButton.enabled = false
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let index = memoriesSegmentedButton.selectedSegmentIndex
        if index == 1{
            self.storiesSelected = storiesArray[indexPath.row]
        }else{
            self.pictureTaken = imageArray[indexPath.row].innerImage
        }
    }
    
    
    
    
    
    
    //MARK: SEGUE & SEGMENTED CONTROL
    @IBOutlet weak var memoriesSegmentedButton: UISegmentedControl!
    @IBAction func memoriesSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            selectButton.enabled = true
            initImageArray()
            //            memoriesCollectionView.reloadData()
            break
        case 1:
            selectButton.enabled = false
            selectMode = false
            //initImageArray()
            //            memoriesCollectionView.reloadData()
            break
        case 2:
            initiatePhotoLibrary()
        default:
            break
        }
    }
    
    //@IBOutlet weak var snapView: UIView!
    
    private var pictureTaken: UIImage?{
        didSet{
            performSegueWithIdentifier(Storyboard.ShowPicture, sender: nil)
        }
    }
    
    private var storiesSelected: [ImageObject]?{
        didSet{
            performSegueWithIdentifier(Storyboard.ShowEnforced, sender: nil)
        }
    }
    
    private struct Storyboard
    {
        static var ShowCamara = "Show Camera"
        static var ShowPicture = "Show Picture"
        static var ShowEnforced = "Show Enforced"
    }
    
    
    //在你需要的地方调用就可以用了
    //记得上面要改class MemoriesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func initiatePhotoLibrary(){
        dispatch_async(dispatch_get_main_queue(), {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .CurrentContext
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true) {
            
            print("media type: \(info[UIImagePickerControllerMediaType])")
            
            //选好的照片就是下面的image，然后在if里面想干啥就干啥
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                //self.pictureTakenImageView.image = image
                //self.pictureTakenImageView.contentMode = .ScaleAspectFit
                self.pictureTaken = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        self.memoriesSegmentedButton.selectedSegmentIndex = 0
        self.selectButton.enabled = true
        initImageArray()
        //        memoriesCollectionView.reloadData()
    }
    
    
    func goToCamara()
    {
        performSegueWithIdentifier(Storyboard.ShowCamara, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowPicture {
            if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                ivc.backTo = selfSegueIdentifier
                ivc.image = self.pictureTaken
            }
        }else if segue.identifier == Storyboard.ShowEnforced{
            if let svc = segue.destinationViewController.contentViewController as? ShowEnforcedViewController {
                svc.backTo = selfSegueIdentifier
                svc.story = self.storiesSelected
            }
        }
    }
    
}
