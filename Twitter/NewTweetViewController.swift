//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/3/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet)
}

class NewTweetViewController: UIViewController {
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var newTweetTextView: UITextView!
    var currentUser = User.currentUser!
    weak var delegate: NewTweetViewControllerDelegate?
    
    var isReplyTweet = false
    var tweetToReply: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarUrl = NSURL(string: currentUser.profileImageUrl!)
        userNameLabel.text = currentUser.name
        userScreenNameLabel.text = "@\(currentUser.screenname!)"
        userAvatarImageView.setImageWithURL(avatarUrl!)
        
        if isReplyTweet == true {
            if let tweet = tweetToReply {
                newTweetTextView.text = "@\(tweet.user!.screenname!)"
            }
        }
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        setupTweetBarButton()
    }
    
    func setupTweetBarButton() {
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: nil, action: "sendTweet")
        let tweetCharCount = UILabel()
//        tweetCharCount.text =
        navigationItem.rightBarButtonItems = [tweetButton]
    }
    
    func sendTweet() {
        guard newTweetTextView.text.characters.count <= 0 else {
            var params = ["status": newTweetTextView.text]
            if isReplyTweet == true {
                params["in_reply_to_status_id"] = "\(tweetToReply!.id!)"
            }
            TwitterClient.sharedInstance.tweetMessageWithParams(params) {
                (tweet: Tweet?, error: NSError?) -> Void in
                if error != nil {
                    print("error sending tweet \(error)")
                } else {
                    self.delegate?.newTweetViewController?(self, didTweet: tweet!)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            return
        }
    }
}

