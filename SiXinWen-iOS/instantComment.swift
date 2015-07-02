//
//  instantComment.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/14.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloudIM


//  data source of comment tableview for instant comments
class instantComment: UITableViewController {

    var currentNewsItem:NewsItem!
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
//    return the number of instant comments that should be loaded
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        return currentNewsItem.instantComment.loadedMessages.count
    }
    

    
//    return the table cell for instant commments
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get the cell
        let cellIdentifier = NSStringFromClass(BubbleCell)
        var  cell = BubbleCell(style: .Default, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = bgColor
        // get the comment
        let singlecomment = currentNewsItem.instantComment.loadedMessages[indexPath.row]
    
        // configure the cell with this instant comment
        cell.configureWithInstantMessage(singlecomment)
        
        // set the avatar asynch..ly
        var userId = singlecomment.clientId
        var query = AVUser.query()
        query.whereKey("username", equalTo: userId)
        query.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if error == nil && result.count > 0{
                var user = result[0] as! AVUser
                var avartarFile = user.objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                        avartarFile?.getThumbnail(true, width: 60, height: 60){
                        (img:UIImage!, error:NSError!) -> Void in
                        if error == nil{
                                cell.usrPhoto.image = img
                        }
                    }
                }

            }

        }
        return cell
        
    }
}
