//
//  UserActionsCell.swift
//  Twitter
//
//  Created by Matthew Goo on 10/4/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class UserActionsCell: UITableViewCell {

    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        didSet {
            if tweet.favorited == true {
                favoriteImageView.image = UIImage(contentsOfFile: "favorite_on")
            }
            if tweet.retweeted == true {
                retweetImageView.image = UIImage(contentsOfFile: "retweet_on")
            }
        }
    }


}
