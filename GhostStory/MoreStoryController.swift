//
//  MoreStoryController.swift
//  GhostStory
//
//  Created by Imran Rahman on 8/21/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit
import GoogleSignIn

class MoreStoryController: UITableViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var options = [MoreData]()
    var checkLogin: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        createOptions()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil){
            checkLogin = true
        }else{
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch options[indexPath.row].name  {
        case "Submit New Story":
            if checkLogin == true{
                performSegue(withIdentifier: "submitNewStory", sender: nil)
            }
        case "Share as a Coffee":
            ()
        default:
            break
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = options[indexPath.row].image
        cell.textLabel?.text = options[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        cell.imageView?.tintColor = .white
        return cell
    }
    
   
    
    func createOptions(){
       options.append(MoreData(name: "Submit New Story", image: UIImage(named: "Plus")))
        options.append(MoreData(name: "Share as a Coffee", image: UIImage(named: "coffee")))
       
    }


}
