//
//  SuggestionsListVC.swift
//  HintPod
//
//  Created by Marawan Alwaraki on 21/03/2019.
//

import UIKit
import SafariServices
import MessageUI

class SuggestionsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SuggCellDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noSuggestionsLabel: UILabel!
    
    var suggestionAlert: AddSuggestionAlert?
    
    var suggestions: [Suggestion] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let bundle = Bundle(for: self.classForCoder)
        suggestionAlert = bundle.loadNibNamed("AddSuggestionAlert", owner: self, options: nil)!.last as? AddSuggestionAlert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSuggestions()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func loadSuggestions() {
        APIManager.loadSuggestions(success: { (suggestions) in
            self.suggestions = suggestions.sorted{($0.voteCount ?? 0 > $1.voteCount ?? 0)}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.noSuggestionsLabel.isHidden = suggestions.count != 0
            }
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionsListCell") as! SuggestionsListCell
        let suggestion = suggestions[indexPath.row]
        cell.loadCell(with: suggestion)
        
        if let userId = UserDefaults.standard.string(forKey: "HPUserId") {
            cell.checkVotes(for: userId, with: suggestion)
        }
        
        cell.delegate = self
        return cell
    }
    
    func tappedUpvote(_ cell: SuggestionsListCell, selected: Bool) {
        vote(cell: cell, upvote: true, selected: selected)
    }
    
    func tappedDownvote(_ cell: SuggestionsListCell, selected: Bool) {
        vote(cell: cell, upvote: false, selected: selected)
    }
    
    func vote(cell: SuggestionsListCell, upvote: Bool, selected: Bool) {
        let suggestion = suggestions[tableView.indexPath(for: cell)!.row]
        guard let suggestionId = suggestion.id else {
            print("can't find suggestion id")
            return;
        }
        
        guard let userId = UserDefaults.standard.string(forKey: "HPUserId") else {
            return;
        }
        
        if selected {
            suggestion.votes[userId] = upvote
        } else {
            suggestion.votes[userId] = nil
        }
        
        APIManager.vote(suggestionId: suggestionId, upvote: upvote, voting: selected, success: {
            print("successfully voted")
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func composeTapped(_ sender: Any) {

        let bundle = Bundle(for: self.classForCoder)
        suggestionAlert = bundle.loadNibNamed("AddSuggestionAlert", owner: self, options: nil)!.last as? AddSuggestionAlert
        suggestionAlert!.present()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Suggestion2Comments" {
            
            var indexPath = tableView.indexPathForSelectedRow
            if indexPath == nil {
                indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            }
            
            let suggestion = suggestions[indexPath!.row]
            
            if let vc = segue.destination as? CommentsListVC {
                vc.suggestion = suggestion
            }
        }

    }
    
    @IBAction func tappedHintpodBanner(_ sender: Any) {
        let alert = UIAlertController(title: "HintPod", message: "This suggestions screen is powered by HintPod.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Visit website", style: .default, handler: { (action) in
            if let url = URL(string: "https://hintpod.com") {
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Get in touch", style: .default, handler: { (action) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["founders@hintpod.com"])
                self.present(mail, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
