//
//  ICATTimelineViewCell.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit
import SDWebImage

class ICATTimelineViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    func updateCell(timelineModel: ICATTimelineModel) {
        self.name.text = "@" + timelineModel.screenName
        self.displayName.text = timelineModel.name
        self.tweet.text = timelineModel.tweet
        self.profileImageView.sd_setImageWithURL(NSURL(string: timelineModel.profileUrl))
    }
    
    func isSelected(isSelected: Bool) {
        if (isSelected) {
            self.backgroundColor = UIColor(red: 198/255.0, green: 227/255.0, blue: 219/255.0, alpha: 1)
        } else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}