//
//  StoryDetailsController.swift
//  GhostStory
//
//  Created by Imran Rahman on 5/27/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit
import GoogleSignIn
import Cosmos
import TinyConstraints
class StoryDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func review(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "rating", sender: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentBox: UITextField!
    @IBAction func commentSubmit(_ sender: UIButton) {
        DatabaseHelper.shared.insertComment(Comment(storyId: story?.id, userId: GIDSignIn.sharedInstance()?.currentUser.userID, comment: commentBox.text))
        self.commentBox.text = nil
    }
    var story: Story?
    
    var comment = [Comment](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String(story?.title?.prefix(20) ?? "")
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name.init(rawValue: "ReloadTableView"), object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailsCell", for: indexPath) as! StoryDetailsCell
            cell.storyTitle.text = story?.title
            cell.storyDetails.text = story?.description
            let goldenTextAttribute = [NSAttributedString.Key.foregroundColor : UIColor(named: "Golden Color")!]
            let whiteTextAttribute = [NSAttributedString.Key.foregroundColor : UIColor.white]
            let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(story?.rating ?? 0.0)", attributes: goldenTextAttribute))
            mutableAttributedString.append(NSAttributedString(string: " / 5.0", attributes: whiteTextAttribute))
            cell.storyRating.attributedText = mutableAttributedString
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCommentCell", for: indexPath) as! StoryCommentCell
            cell.userComment.text = comment[indexPath.row-1].comment
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storyId = story?.id {
            DatabaseHelper.shared.getStoryComments(storyId) { (comments) in
                self.comment = comments
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rating",
            let desVC = segue.destination as? RatingController {
            desVC.story = self.story
        }
    }
    
    @objc func reloadTableView(_ sender: Notification) {
        if let ratings = sender.userInfo?["rating"] as? Double {
            story?.rating = ratings
        }
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


