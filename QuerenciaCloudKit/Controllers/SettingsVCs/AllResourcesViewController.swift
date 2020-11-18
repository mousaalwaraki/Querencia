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
        if let imageUrlString = resource.imageUrl, let imageUrl = URL(string: imageUrlString) {
            cell?.headerImageView.hnk_setImageFromURL(imageUrl)
        }
        return cell!
    }
    

    @IBOutlet weak var allResourceTable: UITableView!
    var resources: [AllResources] = []
    var chosenChoice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allResourceTable.delegate = self
        allResourceTable.dataSource = self
        
        title = resourceChoice!.getTitle()
        chosenChoice = resourceChoice!.getCase()
        
        
        
        PublicCoreDataManager().load("AllResources") { [self] (returnedArray: [NSManagedObject]) in
            let allResources = returnedArray as! [AllResources]
            for resource in allResources {
                if allResources.contains(where: {_ in (resource.category == chosenChoice)}) {
                    resources.append(resource)
                }
            }
            allResourceTable.reloadData()
        }
    }
}
