//
//  AddSuggestionAlert.swift
//  HintPod
//
//  Created by Marwan Elwaraki on 28/05/2019.
//

import UIKit

class AddSuggestionAlert: UIView {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func tappedSubmit(_ sender: Any) {
        
        self.tappedCancel(self)
        
        guard let title = titleField.text else {
            return
        }
        
        guard let description = descriptionTextView.text else {
            return
        }
        
        if title == "" || description == "" {return}
        
        HintPod.suggestionsListVC?.loadingIndicator.startAnimating()
        
        APIManager.addSuggestion(title: title, content: description, success: {
            HintPod.suggestionsListVC?.loadSuggestions()
        }) { (error) in
            HintPod.suggestionsListVC?.loadingIndicator.stopAnimating()
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
        
        titleField.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            titleField.layer.borderColor = UIColor.tertiaryLabel.cgColor
        } else {
            titleField.layer.borderColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor
        }
        titleField.layer.cornerRadius = 6
        
        descriptionTextView.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            descriptionTextView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        } else {
            descriptionTextView.layer.borderColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor
        }
        descriptionTextView.layer.cornerRadius = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
