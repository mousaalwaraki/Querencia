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
    var allPrompts = ["What is something I did today that I am proud of?", "If I could change anything about my day it would be... because...", "The weather outside my window right now is... and it's making me feel...", "What are some things I am grateful for today?", "What are some of my fears and why are they so scary?", "Dear me one year from now…", "Dear childhood friend…", "Relive a favorite childhood memory, what makes this stand out?",  "Dear teenage me…", "What is something I need to forgive myself for?", "What is something I need to forgive someone else for?", "What are some things I would love to start doing and why?", "What is something that is making me feel down lately? How can I change it?", "How can I be more positive during my day?", "I have never told anyone this before…", "I am thankful for these people in my life. What have they taught me?", "I am so glad I got to meet … because...", "Here are some things I love about my job…", "These are some nice things I have done for others lately…", "Here are some nice things others have done for me lately…", "Three emotions I am feeling right now and why…", "I feel great when I…", "These are some of my personal self-care moments…", "Happiness to me means…", "I am happiest when I am with…", "What are some short-term goals I would love to accomplish?", "The quote I'd like to reflect on today is... , it resonated with me because...", "What are some negative beliefs I have about myself sometimes? How are they untrue?", "What were some highlights of my day?", "How many meals have I eaten today, what did they consist of and how did they make me feel?", "Did I work out today? How has my mood cahnged after exercising?", "Did I experience any pain today? What caused it?", "Did I use my free time wisely?", "Did I cry today? Was it from joy or pain? How did my mood alter after?"]
}
