//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBAction func onLogout(sender: UIButton) {
        User.currentUser?.logout()
    }
}
