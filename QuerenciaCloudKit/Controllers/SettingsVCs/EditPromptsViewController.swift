//
//  EditPromptsViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit

class EditPromptsViewController: UIViewController, QuestionCellDelegate, UITextViewDelegate {
    
    @IBOutlet weak var inspirationCard: UIView!
    @IBOutlet weak var inspirationButton: UIButton!
    @IBOutlet weak var questionsTableView: UITableView!
    
    var chosenJournal: UserJournals?
    var questions = [String]()
    var journalTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addQuestion))
        self.navigationItem.rightBarButtonItem  = addButton
        
        journalTitle = chosenJournal?.title
        questions = chosenJournal?.questions ?? []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CoreDataManager().updateUserJournalQuestions(journalTitle!, questions)
    }
    
    @objc func addQuestion() {
        questions.append("")
        questionsTableView.insertRows(at: [IndexPath(row: questions.count - 1, section: 0)], with: .automatic)
        questionsTableView.scrollToRow(at: IndexPath.init(row: questions.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func updateArray(cell: UITableViewCell) {
        
        guard let indexPath = questionsTableView.indexPath(for: cell) else { return }
        let cell = cell as! QuestionsTableViewCell
        var questionCell = questions[indexPath.row]
        questionCell = cell.questionsTextView.text
        questions[indexPath.row] = questionCell
        CoreDataManager().updateUserJournalQuestions(journalTitle!, questions)
    }
    
    @IBAction func needInspoButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "InspirationViewController") as? InspirationViewController
        vc?.userjournal = chosenJournal
        navigationController?.pushViewController(vc!, animated: true)
        
    }
}

extension EditPromptsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionsCell") as! QuestionsTableViewCell
        
        cell.cardView.setCard()
        cell.questionsTextView.text = questions[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            questions.remove(at: indexPath.row)
            CoreDataManager().updateUserJournalQuestions(journalTitle!, questions)
            tableView.reloadData()
        }
    }
}
