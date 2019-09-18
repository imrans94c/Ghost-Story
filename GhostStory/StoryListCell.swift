//
//  StoryListCell.swift
//  GhostStory
//
//  Created by Imran Rahman on 5/20/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit

class StoryListCell: UITableViewCell {
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var storyPreview: UILabel!
    @IBOutlet weak var storyRating: UILabel!
}


//MARK: Story Stuct

struct Story {
    var id: String?
    var title: String?
    var description: String?
    var rating: Double = 0.0
    
    init(title: String?, description: String?, rating: Double = 0.0, id: String? = nil) {
        self.title = title
        self.description = description
        self.rating = rating
        self.id = id
    }
    
}

struct Comment {
    var storyId: String?
    var userId: String?
    var comment:String?
    
    init(storyId: String? = nil, userId: String? = nil, comment: String? ) {
        self.storyId = storyId
        self.userId = userId
        self.comment = comment
    }
}

struct Rating {
    var storyId : String?
    var userId : String?
    var rating : Double = 0.0
}

