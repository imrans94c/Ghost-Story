//
//  StoryListController.swift
//  GhostStory
//
//  Created by Imran Rahman on 5/20/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit

class StoryListController: UITableViewController {
    
    //    @IBAction func refreshStories(_ sender: Any) {
    //        JHToasterPresenter.presentOnWindow(with: nil, "Loading...", UIColor.init(named: "Primary Color"), .white)
    //        stories = []
    //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.50) {
    //            DatabaseHelper.shared.getAllStories(completion: { stories in
    //                self.stories = stories
    //            })
    //        }
    //    }
    
    @IBAction func moreTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "more", sender: nil)
        
    }  
    
    @IBAction func userProfile(_ sender: UIBarButtonItem) {
        
        let userDefault = UserDefaults.standard
        
        let savedData = userDefault.bool(forKey: "isLoggedIn")
        if(savedData){
            performSegue(withIdentifier: "userProfile", sender:nil)
        }else{
          
            print("You should login first.")
        }
        
    }
    
    @IBAction func unwindToStoryList(_ sender: UIStoryboardSegue) {
        
    }
    
    var stories = [Story]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.black
        let refresher = UIRefreshControl()
        refreshControl = refresher
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        if Helper.shared.isInternetAvailable() {
            JHToasterPresenter.presentOnWindow(with: nil, "Loading...", UIColor.init(named: "Primary Color"), .white)
            DatabaseHelper.shared.getAllStories(completion: { stories in
                self.stories = stories
                self.tableView.reloadData()
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryListCell", for: indexPath) as! StoryListCell
        cell.storyTitle.text = stories[indexPath.row].title
        let random = Int.random(in: 100...300)
        cell.storyPreview.text = String(stories[indexPath.row].description?.prefix(random) ?? "")
        
        let goldenTextAttribute = [NSAttributedString.Key.foregroundColor : UIColor(named: "Golden Color")!]
        let whiteTextAttribute = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(stories[indexPath.row].rating)", attributes: goldenTextAttribute))
        mutableAttributedString.append(NSAttributedString(string: " / 5.0", attributes: whiteTextAttribute))
        cell.storyRating.attributedText = mutableAttributedString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "StoryDetails", sender: stories[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryDetails",
            let desVC = segue.destination as? StoryDetailsController {
            desVC.story = sender as? Story
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if Helper.shared.isInternetAvailable() {
            JHToasterPresenter.presentOnWindow(with: nil, "Loading...", UIColor.init(named: "Primary Color"), .white)
            stories = []
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.50) {
                DatabaseHelper.shared.getAllStories(completion: { stories in
                    self.stories = stories
                    if self.refreshControl?.isRefreshing ?? false {
                        self.refreshControl?.endRefreshing()
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: {
                if self.refreshControl?.isRefreshing ?? false {
                    self.refreshControl?.endRefreshing()
                }
            })
        }
    }
}