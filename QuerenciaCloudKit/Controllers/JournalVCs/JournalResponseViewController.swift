//
//  JournalResponseViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import CoreData

class JournalResponseViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    
    var chosenJournal: JournalModel?
    var combinedCurrentDate: String?
    var number: Int?
    var journalEntry: UserResponses?
    var entryQuestion = [String]()
    var entryResponses = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        questionLabel.text = chosenJournal?.questions![number!]
        
        getTodaysDate()
        
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            let entries = returnedArray as? [UserResponses]
            for entry in entries ?? [] {
                if entry.date == combinedCurrentDate {
                    journalEntry = entry
                }
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if answerTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            entryQuestion.append(questionLabel.text!)
            entryResponses.append(answerTextView.text)
        }
        
        if number != (chosenJournal?.questions!.count)! - 1 {
            let vc = JournalResponseViewController()
            vc.chosenJournal = chosenJournal
            vc.entryQuestion = entryQuestion
            vc.entryResponses = entryResponses
            vc.number = number! + 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            CoreDataManager().save(combinedCurrentDate!, journalEntry?.dayFeeling ?? 1000, entryQuestion , entryResponses , journalEntry?.dayTags ?? [], chosenJournal?.userTitle ?? "")
            
            let story = UIStoryboard(name: "Main", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "tabBar")
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func getTodaysDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let combinedDate = calendar.date(from:components)!
        combinedCurrentDate = formatter.string(from: combinedDate)
    }
    
}
