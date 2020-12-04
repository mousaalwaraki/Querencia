//
//  AllResourcesViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/12/20.
//

import UIKit
import CoreData

class AllResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? ResourceTableViewCell
        let resource = resources[indexPath.row]
        
        cell?.titleLabel.text = resource.title
        cell?.descriptionLabel.text = resource.subtitle
        let imageUrlString = resource.imageUrl
        let imageUrl = URL(string: imageUrlString)
        cell?.headerImageView.hnk_setImageFromURL(imageUrl!)
        
        return cell!
    }
    

    @IBOutlet weak var allResourceTable: UITableView!
    var resources: [Resource] = []
    var chosenChoice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allResourceTable.delegate = self
        allResourceTable.dataSource = self
        
        title = resourceChoice!.getTitle()
        chosenChoice = resourceChoice!.getCase()
        
        PublicCoreDataManager().loadPublic("Resource") { [self] (records) in
            resources.removeAll()
            for record in records {
                if Resource(record: record).category == chosenChoice {
                    resources.append(Resource(record: record))
                }
            }
            DispatchQueue.main.async {
                allResourceTable.reloadData()
            }
        }
    }
}
