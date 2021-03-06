//
//  TweetCell.swift
//  Twitter
//
//  Created by Matthew Goo on 10/3/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCellDelegate(tweetCell: TweetCell, didTapRetweet tweet: Tweet)
    optional func tweetCellDelegate(tweetCell: TweetCell, didTapFavorite tweet: Tweet)
    optional func tweetCellDelegate(tweetCell: TweetCell, didTapReply tweet: Tweet)
}

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
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            if let text = tweet.text {
                messageLabel.text = text
            }
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
                if tweet.retweeted == true {
                    retweetImageView.image = UIImage(named: "retweet_on")
                }
                if tweet.favorited == true {
                    favoriteImageView.image = UIImage(named: "favorite_on")
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let retweetImageView = retweetImageView {
            let tapRetweetRecognizer = UITapGestureRecognizer(target: self, action: "onRetweetTap:")
            retweetImageView.userInteractionEnabled = true
            retweetImageView.addGestureRecognizer(tapRetweetRecognizer)
            
            let tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: "onFavoriteTap:")
            favoriteImageView.userInteractionEnabled = true
            favoriteImageView.addGestureRecognizer(tapFavoriteRecognizer)
            
            
            let tapReplyRecognizer = UITapGestureRecognizer(target: self, action: "onReplyTap:")
            replyImageView.userInteractionEnabled = true
            replyImageView.addGestureRecognizer(tapReplyRecognizer)
        }
    }
    
    func onRetweetTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.tweetCellDelegate?(self, didTapRetweet: tweet)
    }
    
    func onFavoriteTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.tweetCellDelegate?(self, didTapFavorite: tweet)
    }
    
    func onReplyTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.tweetCellDelegate?(self, didTapReply: tweet)
    }
    
    func setRetweet(tweet: Tweet) {
        if tweet.retweeted == true {
            retweetImageView.image = UIImage(named: "retweet_on")
        } else {
            retweetImageView.image = UIImage(named: "retweet")
        }
    }
}
