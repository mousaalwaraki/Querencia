//
//  EditActivityViewController.swift
//  QuerenciaCloudKit
//
//  Created by Marwan Elwaraki on 28/11/2020.
//

import UIKit
import CoreData

class EditActivityViewController: UIViewController {

    @IBOutlet weak var activitiesTable: UITableView!
    
    var activities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activitiesTable.delegate = self
        activitiesTable.dataSource = self
        loadActivities()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add Activity", message: "What activity would you like to add?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self] _ in
            activities.append(alert.textFields?[0].text ?? "")
            CoreDataManager().saveUserTags(activities)
            activitiesTable.reloadData()
            activitiesTable.scrollToRow(at: IndexPath(row: activities.count - 1, section: 0), at: .bottom, animated: true)
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true)
    }
    
    func loadActivities() {
        CoreDataManager().load("UserTags") { [self] (returnedArray: [NSManagedObject]) in
            let activity = returnedArray as! [UserTags]
            activities = activity[0].allTags ?? []
            activitiesTable.reloadData()
        }
    }
}

extension EditActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editActivities", for: indexPath) as! EditPromptsTableViewCell
        cell.promptLabel.text = activities[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Activity", message: "What would you like to edit your activity to?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self] _ in
            activities[indexPath.row] = alert.textFields?[0].text ?? ""
            CoreDataManager().saveUserTags(activities)
            activitiesTable.reloadData()
        }))
        alert.addTextField { [self] (textField) in
            textField.text = activities[indexPath.row]
        }
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            activities.remove(at: indexPath.row)
            CoreDataManager().saveUserTags(activities)
            activitiesTable.reloadData()
        }
    }
}
