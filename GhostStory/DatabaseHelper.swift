//
//  DatabaseHelper.swift
//  GhostStory
//
//  Created by Imran Rahman on 5/23/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GoogleSignIn

final class DatabaseHelper {
    static var shared = DatabaseHelper()
    private init() {}
    var ref = Database.database().reference()
    
    func storeStory(_ story: Story){
        let userId = GIDSignIn.sharedInstance()?.currentUser.userID
        if let key = ref.childByAutoId().key {
            let dictionary: [String : Any] = ["id" : key,
                                              "userId" : userId ?? "",
                                              "title": story.title ?? "",
                                              "preview" : story.description ?? "",
                                              "rating": story.rating]
            ref.child("Stories").child(key).setValue(dictionary)
        }
    }
    
    func getAllStories(completion: @escaping (_ stories: [Story])->()) {
        ref.child("Stories").observe(.value) { (snap) in
            var stories: [Story] = []
            if let allObjects = snap.children.allObjects as? [DataSnapshot] {
                for object in allObjects {
                    if let obj = object.value as? Dictionary<String, Any>,
                        let title = obj["title"] as? String,
                        let preview = obj["preview"] as? String,
                        let rating = obj["rating"] as? Double,
                        let id = obj["id"] as? String {
                        stories.append(Story(title: title, description: preview, rating: rating, id: id))
                    } else {
                        print("\n\nStories fetch or mapping issue.\n\n")
                    }
                }
                stories = stories.reversed()
                completion(stories)
                JHToasterPresenter.hideFromWindow()
            }
        }
    }
    
    func insertComment(_ comment : Comment){
        if let key = ref.childByAutoId().key {
            let dictionary: [String : Any] = ["story_id": comment.storyId ?? "", "user_id": comment.userId ?? "",
                                              "comment": comment.comment ?? ""]
            ref.child("Comments").child(key).setValue(dictionary)
        }
    }
    
    func insertRating(_ rating : Rating){
        if let key = ref.childByAutoId().key{
            let dictionary: [String : Any] = ["story_id": rating.storyId ?? "", "user_id": rating.userId ?? "", "rating": rating.rating]
            ref.child("Ratings").child(key).setValue(dictionary)
        }
    }
    
    func saveAvgRating(_ avgrating : Double, _ storyId : String ){
        ref.child("Stories").child(storyId).child("rating").setValue(avgrating)
    }
    
    func getStoryComments(_ storyId: String, completion: @escaping (_ comments: [Comment])->Void){
        ref.child("Comments").queryOrdered(byChild: "story_id").queryEqual(toValue: storyId).observe(.value) { (snap) in
            var comments: [Comment] = []
            if let allObjects = snap.children.allObjects as? [DataSnapshot]{
                for object in allObjects {
                    if let obj = object.value as? Dictionary<String, Any>,
                        let comment = obj["comment"] as? String{
                        comments.append(Comment(comment: comment))
                    }else{
                        print("\n\nComments fetch or mapping issue.\n\n")
                    }
                }
            }
            completion(comments)
        }
    }
    
    func getStoryRatings(_ storyId: String, completion: @escaping (_ ratings: [Rating])->Void){
        ref.child("Ratings").queryOrdered(byChild: "story_id").queryEqual(toValue: storyId).observe(.value) { (snap) in
            var ratings: [Rating] = []
            if let allObjects = snap.children.allObjects as? [DataSnapshot]{
                for object in allObjects {
                    if let obj = object.value as? Dictionary<String, Any>,
                        let rating = obj["rating"] as? Double{
                        ratings.append(Rating(storyId: storyId, rating: rating))
                    } else {
                        print("\n\nStory Rating fetch or mapping issue.\n\n")
                    }
                }
            }
            completion(ratings)
        }
    }
    
    func myStory(completion: @escaping(_ stories: [Story])-> ()) {
        let userId = GIDSignIn.sharedInstance()?.currentUser.userID
        if let user_id = userId {
            ref.child("Stories").queryOrdered(byChild: "userId").queryEqual(toValue: user_id).observe(.value) { (snap) in
                var mystories: [Story] = []
                if let allObjects = snap.children.allObjects as? [DataSnapshot]{
                    for object in allObjects{
                        if let obj = object.value as? Dictionary<String, Any>{
                            mystories.append(Story(title: obj["title"] as? String, description: obj["preview"] as? String, rating: obj["rating"] as! Double, id: obj["id"] as? String))
                        }
                    }
                    mystories = mystories.reversed()
                    completion(mystories)
                    JHToasterPresenter.hideFromWindow()
                }
            }
        }
    }
    
    
    func getUserRating(storyId: String, completion: @escaping (_ curentUserRating: Rating) -> Void){
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            ref.child("Ratings").queryOrdered(byChild: "user_id").queryEqual(toValue: user.userID).observe(.value){
                (snap) in
                
                var currentUserRating: [Rating] = []
                if let allObjects = snap.children.allObjects as? [DataSnapshot]{
                    for object in allObjects {
                        if let obj = object.value as? Dictionary<String, Any>,
                            let rating = obj["rating"] as? Double,
                            let story_id = obj["story_id"] as? String {
                            currentUserRating.append(Rating(storyId: story_id, userId: user.userID, rating: rating))
                        } else {
                            print("\n\nUser Rating fetch or mapping issue.\n\n")
                        }
                    }
                    currentUserRating = currentUserRating.filter { $0.storyId == storyId }
                    print(currentUserRating)
                    if !currentUserRating.isEmpty {
                        completion(currentUserRating.last!)
                    }
                }
                
            }
        }
    }
    
    
    
}
