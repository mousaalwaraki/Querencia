//
//  InspirationViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import CoreData

class InspirationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PromptsCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPrompts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = promptsTableView.dequeueReusableCell(withIdentifier: "PromptsCell") as! PromptsTableViewCell
        cell.delegate = self
        cell.vc = self
        cell.promptTextView.text = allPrompts[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var randomPromptCard: UIView!
    @IBOutlet weak var randomPromptButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var randomPromptView: UIView!
    @IBOutlet weak var randomPromptText: UITextView!
    @IBOutlet weak var promptsTableView: UITableView!
    @IBOutlet weak var promptAddedView: UIView!
    @IBOutlet weak var cycleCompletedView: UIView!
    
    
    var allPrompts: [String] = []
    var userPrompts: [String] = []
    var randomPrompts: [String] = []
    var number = 0
    var userjournal: UserJournals?
    var journalTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        randomPromptCard.setCard()
        promptAddedView.setCard()
        randomPromptView.setCard()
        
        promptsTableView.delegate = self
        promptsTableView.dataSource = self
        
        cycleCompletedView.alpha = 0
        journalTitle = userjournal?.title
        
        PublicCoreDataManager().load("AllPrompts") { [self] (returnedArray: [NSManagedObject]) in
            let allOnlinePrompts = returnedArray as? [AllPrompts]
            allPrompts = allOnlinePrompts![0].allPrompts!
        }
        
        CoreDataManager().load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            let journals = returnedArray as? [UserJournals]
            if journals?.count == 0 { return }
            for journal in journals! {
                if journal == userjournal {
                    for question in journal.questions ?? [] {
                        userPrompts.append(question)
                    }
                }
            }
            for question in userPrompts {
                    allPrompts.removeAll(where: {$0 == question})
            }
        }
        promptsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CoreDataManager().updateUserJournalQuestions(journalTitle!, userPrompts)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        randomize()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
//        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
//        docRef.updateData(["questions": FieldValue.arrayUnion([self.randomPromptText.text!])])
//
//        let ref = db.collection("dailyEntries").document("\(Auth.auth().currentUser?.uid ?? "Something")-\(Date().simpleDate())")
//        let dict = [self.randomPromptText.text!: ""]
//        ref.updateData(["response": FieldValue.arrayUnion([dict])])
        
        userPrompts.append(randomPromptText.text)
        
        promptAddedShow()
    }
    
    @IBAction func randomButtonTapped(_ sender: Any) {
        randomize()
        UIView.animate(withDuration: 0.3) {
            self.randomPromptView.alpha = 1
            self.backgroundView.alpha = 0.5
        }
    }
    
    func randomElement() {
        randomPromptText.text = randomPrompts[number]
        number += 1
    }
    
    func randomize() {
        if number < randomPrompts.count {
            randomElement()
            self.cycleCompletedView.alpha = 0
        } else {
            number = 0
            for item in 0...allPrompts.count - 1 {
                randomPrompts.append(allPrompts[item])
            }
            randomElement()
            UIView.animate(withDuration: 0.3) {
                self.cycleCompletedView.alpha = 1
            }
        }
    }
    
    @IBAction func backgroundViewTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
            self.randomPromptView.alpha = 0
        }
    }
    
    func promptAddedShow() {
        
        UIView.animate(withDuration: 0.3) {
            self.promptAddedView.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    self.promptAddedView.alpha = 0
                }
            }
        }
        
    }
}
