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
    
    var rating: Double = 0
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ratingView.didFinishTouchingCosmos = { rating in
            self.rating = rating
        }
    }
    
    @IBAction func crossRating(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitRating(_ sender: UIButton) {
        DatabaseHelper.shared.insertRating(Rating(storyId: story?.id, userId: GIDSignIn.sharedInstance()?.currentUser.userID, rating: rating))
        self.dismiss(animated: true, completion: nil)
    }
}
