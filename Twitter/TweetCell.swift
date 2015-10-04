//
//  TweetCell.swift
//  Twitter
//
//  Created by Matthew Goo on 10/3/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            messageLabel.text = tweet.text
            if tweet.retweeted == true {
                retweetImageView.hidden = false
//                retweetedLabel.text = tweet.userRetweet?.name
            }
            if let user = tweet.user {
                let avatarUrl = NSURL(string: user.profileImageUrl!)
                nameLabel.text = user.name
                usernameLabel.text = "@\(user.screenname!)"
                avatarImage.setImageWithURL(avatarUrl)
            }
            timeLabel.text = tweet.timeSince

        }
    }
}
