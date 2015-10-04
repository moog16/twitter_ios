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
    @IBOutlet weak var fullTimeLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var wasRetweetedImage: UIImageView!
    
    var isSingleTweetView = false
    
    var tweet: Tweet! {
        didSet {
            if let text = tweet.text {
                messageLabel.text = text
            }
//            if tweet.retweeted == true {
//                wasRetweetedImage.hidden = false
//                retweetedLabel.text = tweet.userRetweet?.name
//            }
            if let user = tweet.user {
                let avatarUrl = NSURL(string: user.profileImageUrl!)
                nameLabel.text = user.name
                usernameLabel.text = "@\(user.screenname!)"
                avatarImage.setImageWithURL(avatarUrl)
            }
            
            if isSingleTweetView == true {
                if let createdAt = tweet.createdAtString {
                    print(createdAt)
                    fullTimeLabel.text = createdAt
                }
            } else {
                wasRetweetedImage.hidden = true
                if let timeSince = tweet.timeSince {
                    timeLabel.text = "\(timeSince)"
                }
            }
        }
    }
}
