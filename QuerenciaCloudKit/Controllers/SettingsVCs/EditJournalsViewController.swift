//
//  EditJournalsViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/14/20.
//

import UIKit
import CoreData

class EditJournalsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var journalsTable: UITableView!
    
    var renameTextField:UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var journals = [UserJournals]()
    var newJournal: UserJournals?
    var oldName: String = ""
    var newName: String?
    var numberInArray: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        journalsTable.delegate = self
        journalsTable.dataSource = self
        renameTextField.delegate = self
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addJournal))
        self.navigationItem.rightBarButtonItem  = addButton
        
        self.journalsTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager().load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            journals = returnedArray as? [UserJournals] ?? []
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        journals.removeAll()
    }
    func configurationTextField(text: UITextField!) {
        if text != nil {
            self.renameTextField = text!
            self.renameTextField.text = "\(oldName)"
        }
    }
    
    @objc func addJournal() {
        CoreDataManager().saveUserJournals("", "\(journals.count + 1)", [])
        newJournal?.title = "Journal\(journals.count + 1)"
        newJournal?.userTitle = ""
        newJournal?.questions = []
        journals.append(newJournal!)
        journalsTable.reloadData()
        journalsTable.scrollToRow(at: IndexPath.init(row: journals.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension EditJournalsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalNameCells") as! JournalNameTableViewCell
        
        cell.journalNameLabel.text = journals[indexPath.row].userTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        oldName = journals[indexPath.row].userTitle!
        numberInArray = indexPath.row
        
        let alert = UIAlertController(title: nil, message: "What action would you like to perform?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [self] _ in presentEditAlert() }))
        alert.addAction(UIAlertAction(title: "Edit Questions", style: .default, handler: { [self] _ in
            let vc = storyboard?.instantiateViewController(identifier: "EditPromptsViewController") as? EditPromptsViewController
            vc?.chosenJournal = journals[indexPath.row]
//            navigationItem.rightBarButtonItems?.removeAll()
            navigationController?.pushViewController(vc!, animated: true)
//            present(vc!, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete \(journals[indexPath.row].userTitle ?? "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [self] _ in
                CoreDataManager().deleteUserJournal(journals[indexPath.row].title!)
                journals.remove(at: indexPath.row)
                tableView.reloadData()
            }))
            present(alert, animated: true)
        } else if editingStyle == .insert {
            print("insert")
        }
    }
    
    func presentEditAlert() {
        let alert = UIAlertController(title: "Rename Journal", message: "What would you like to rename this journal to?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [self] (UIAlertAction) in
            newName = renameTextField.text
            
            journals[numberInArray!].userTitle = newName
            
            CoreDataManager().updateUserJournalName(journals[numberInArray!].title!, newName ?? "")
            
            let cell = journalsTable.cellForRow(at: IndexPath(row: numberInArray!, section: 0)) as! JournalNameTableViewCell
            cell.journalNameLabel.text = newName
        }))
        alert.addTextField(configurationHandler: configurationTextField(text: ))
        present(alert, animated: true)
    }
}
