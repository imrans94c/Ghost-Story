//
//  NewStoryController.swift
//  GhostStory
//
//  Created by Imran Rahman on 8/22/19.
//  Copyright © 2019 InfancyIT. All rights reserved.
//

import UIKit

class NewStoryController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var storyTitle: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
  
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "UnwindToStoryList", sender: nil)
    }
    
    
    @IBAction func saveNewStory(_ sender: Any) {
        
        var newStory = Story(title: storyTitle.text, description: textView.text)
        
        DatabaseHelper.shared.storeStory(newStory)
        
        performSegue(withIdentifier: "UnwindToStoryList", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "Description"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
                
        else {
            return true
        }
        
        
        return false
    }
    
    
    
}
