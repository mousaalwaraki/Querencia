//
//  ReviewJournalViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/13/20.
//

import UIKit
import CoreData

class ReviewJournalViewController: UIViewController {

    @IBOutlet weak var reviewJournalTable: UITableView!
    @IBOutlet weak var journalName: UILabel!
    @IBOutlet weak var journalDate: UILabel!
    
    var currentResponse = ResponseModel()
    var journalTitle: String?
    var chosenDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        journalName.text = journalTitle
        journalDate.text = chosenDate
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            let userResponse = returnedArray as? [UserResponses]
            for response in userResponse ?? [] {
                if response.date == chosenDate {
                    currentResponse.questions = response.dayQuestions
                    currentResponse.responses = response.dayResponses
                }
            }
        }
        
        reviewJournalTable.delegate = self
        reviewJournalTable.dataSource = self
    }
}

extension ReviewJournalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentResponse.questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalReviewTableViewCell
        
        cell.titleLabel.text = currentResponse.questions?[indexPath.row]
        cell.answerLabel.text = currentResponse.responses?[indexPath.row]
        
        return cell
    }
}
