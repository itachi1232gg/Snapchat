//
//  AddedMeTableViewCell.swift
//  Snapchat
//
//  Created by ailina on 16/10/3.
//  Copyright © 2016年 Can. All rights reserved.
//

import UIKit

class AddedMeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func addFriend(sender: UIButton) {
        
    }
    
    //MARK: 当cell获取到自定义内容（记得更改user类型）
    var cellContent: User?{
        didSet{
            updateUI()
        }
    }
    
    //MARK: 内容与控件内容一一对应
    private func updateUI(){
        //Set nil
        nameLabel?.text = nil
        
        if let cellContent = self.cellContent{
            nameLabel?.text = "\(cellContent.name)"
        }
    }
}
