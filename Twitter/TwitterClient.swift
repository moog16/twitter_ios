//
//  TwitterClient.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit


let twitterConsumerKey = "xxPPoU4qCR82jEY7FjmpNJdBe"
let twitterConsumerSecret = "FUiM2DxO0wea4Wucm9vtJPRwEAbnzkKGlECyjplkudgWNkdDPM"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")!

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let sharedInstance: TwitterClient = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
       requestSerializer.removeAccessToken()
       fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"mattgootwitterios://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in

            let authUrl = NSURL(string: "\(twitterBaseUrl)/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authUrl!)
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user:nil, error: error)
        }
    }
    
    func homeTimeineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success:
                { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                    print("\(response as! [[String: String]])")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                    
                completion(tweets: tweets, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweets: nil, error: error)
        }
    }
    
    func rateLimitWithParams() {
        // check on how many times i've hit end point
        let params = ["resources":"statuses"]
        GET("1.1/application/rate_limit_status.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("\(response)")
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error from rate limiter \(error)")
        }
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
            
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    print("\(response)")
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion!(user: user, error: nil)
                }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                    self.loginCompletion?(user:nil, error: error)
                })
                
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user:nil, error: error)
        }
    }
}


