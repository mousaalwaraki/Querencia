//
//  AddSuggestionAlert.swift
//  HintPod
//
//  Created by Marwan Elwaraki on 28/05/2019.
//

import UIKit

class AddCommentAlert: UIView {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var commentsListVC: CommentsListVC!
    
    @IBAction func tappedSubmit(_ sender: Any) {
        
        self.tappedCancel(self)
        
        guard let comment = commentTextView.text else {
            return
        }
        
        if comment == "" {return}
        
        //add spinner
        
        APIManager.addComment(suggestionId: self.commentsListVC.suggestion.id, comment: comment, success: {
            print("added comment")
            self.commentsListVC.loadNewComment()
        }) { (error) in
            print("error")
            print(error)
        }
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height + self.alertView.frame.height)
        }) { (completed) in
            self.removeFromSuperview()
        }
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.convert(keyboardFrame, from: nil)
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.center.y = self.frame.height - keyboardFrame.height - self.alertView.frame.height/2 - 25
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.convert(keyboardFrame, from: nil)
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.center.y = self.center.y
        }
        
    }
    
    func present() {
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height - self.alertView.frame.height)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        commentTextView.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            commentTextView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        } else {
            commentTextView.layer.borderColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor
        }
        commentTextView.layer.cornerRadius = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
