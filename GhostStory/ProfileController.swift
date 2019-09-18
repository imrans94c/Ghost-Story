//
//  ProfileController.swift
//  GhostStory
//
//  Created by Imran Rahman on 6/27/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var signInButtonView: GIDSignInButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var options = [OptionData]()
     var checkLogin : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        GIDSignIn.sharedInstance()?.signInSilently()
        populateOptions()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.signInButtonView.isHidden = true
            self.userName.text = user.profile.name
            self.userEmail.text = user.profile.email
            do {
                self.userImage.image = UIImage(data: try Data(contentsOf: user.profile.imageURL(withDimension: 300)))
            } catch {
                print(error.localizedDescription)
            }
            checkLogin = true
            populateOptions()
        } else {
            print(error.localizedDescription)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = options[indexPath.row].image
        cell.textLabel?.text = options[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        cell.imageView?.tintColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch options[indexPath.row].name {
        case "New Story":
            if checkLogin == true{
                performSegue(withIdentifier: "newStory", sender: nil)

            }
        case "My Story":
            
            if checkLogin == true{
                performSegue(withIdentifier: "myStory", sender: nil)
                
            }
            
        
        case "Logout":
            GIDSignIn.sharedInstance().signOut()
            self.signInButtonView.isHidden = false
            self.userName.text = "User Name"
            self.userEmail.text = "Email"
            self.userImage.image = UIImage(named: "user")
            checkLogin = false
            populateOptions()
        default:
            break
        }
    }
    
    func populateOptions() {
        options.removeAll()
        options.append(OptionData(name: "New Story", image: UIImage(named: "Plus")))
        options.append(OptionData(name: "My Story", image: UIImage(named: "menu")))
        if (checkLogin){
            options.append(OptionData(name: "Logout", image: UIImage(named: "logout")))
        }
        tableView.reloadData()
    }
}


