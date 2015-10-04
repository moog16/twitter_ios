//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetViewControllerDelegate {
    
    var tweets: [Tweet]?
    var refreshControlTableView: UIRefreshControl!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 100
        
        refreshControlTableView = UIRefreshControl()
        refreshControlTableView.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControlTableView, atIndex: 0)
        
        getHomeTimeline(nil)
    }

    @IBAction func onSignOut(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    func getHomeTimeline(completion:(()->())?) {
        TwitterClient.sharedInstance.rateLimitWithParams()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            if completion != nil {
                completion!()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tweetsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func onRefresh() {
        getHomeTimeline() {
            self.refreshControlTableView.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets?[indexPath.row]
        
        return cell
    }
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet) {
        tweets?.insertContentsOf(tweet, at: 0)
        self.tweetsTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is TweetCell {
            let cell = sender as! TweetCell
            let tweetViewController = segue.destinationViewController as! TweetViewController
            let indexPath = tweetsTableView.indexPathForCell(cell)
            tweetViewController.tweet = tweetsTableView.cellForRowAtIndexPath(indexPath)
        } else {
            let newTweetController = segue.destinationViewController as! NewTweetViewController
            newTweetController.delegate = self
        }
    }
    
}
