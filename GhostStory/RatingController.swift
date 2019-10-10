//
//  RatingController.swift
//  GhostStory
//
//  Created by Imran Rahman on 9/17/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit
import Cosmos
import GoogleSignIn

class RatingController: UIViewController {
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var submit: UIButton!
    var rating: Double = 0
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseHelper.shared.getUserRating(storyId: story?.id ?? "", completion: { rating in
            self.ratingView.rating = rating.rating
            self.submit.isEnabled = false
        })
        // Do any additional setup after loading the view.
        ratingView.didFinishTouchingCosmos = { rating in
            self.rating = rating
//            self.submit.isEnabled = false
        }
    }
    
    @IBAction func crossRating(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitRating(_ sender: UIButton) {
        DatabaseHelper.shared.insertRating(Rating(storyId: story?.id, userId: GIDSignIn.sharedInstance()?.currentUser.userID, rating: rating))
        if let storyId = self.story?.id {
            DatabaseHelper.shared.getStoryRatings(storyId) { (ratings) in
                if ratings.count != 0 {
                    let averageRating = ratings.compactMap { $0.rating }.reduce(0, +) / Double(ratings.count)
                    DatabaseHelper.shared.saveAvgRating(averageRating, storyId)
                    NotificationCenter.default.post(Notification(name: Notification.Name.init("ReloadTableView"), userInfo: ["rating": averageRating]))
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
