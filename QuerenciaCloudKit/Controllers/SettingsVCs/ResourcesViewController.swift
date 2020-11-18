//
//  ResourcesViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import SafariServices
import CoreData

class ResourcesViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    var allTypeButton = UIButton(type: UIButton.ButtonType.system)
    var currentResources : [CurrentResources] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.delegate = self
        newsTable.dataSource = self
        
        PublicCoreDataManager().load("CurrentResources") { [self] (returnedArray: [NSManagedObject]) in
            currentResources = returnedArray as! [CurrentResources]
            newsTable.reloadData()
        }
    }

    @IBAction func settingsButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SettingsViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ResourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (Category.allCases.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        
        if category != .book {
            return currentResources.filter({Category(rawValue: $0.category ?? "") == Category.allCases[section]}).count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //        if section != 2 {
        var footerView: UIView?
        if section != 2 {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        } else { footerView = nil}
        footerView?.backgroundColor = UIColor.clear
        
        allTypeButton = UIButton(type: UIButton.ButtonType.system)
        allTypeButton.backgroundColor = UIColor.systemGray5
        allTypeButton.setTitle("All " + Category.allCases[section].rawValue.capitalizingFirstLetter() + "s", for: UIControl.State.normal)
        allTypeButton.tintColor = .whatsNewKitRed
        allTypeButton.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 40, height: 50)
        allTypeButton.layer.cornerRadius = 12
        allTypeButton.tag = section
        allTypeButton.addTarget(self, action: #selector(buttonTouched(sender:)), for: UIControl.Event.touchUpInside)
        
        footerView?.addSubview(allTypeButton)
        
        return footerView
        //        } else { return }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 2 {
        return 50
        } else { return 1}
    }
    
    @objc func buttonTouched(sender: UIButton) {
        if sender.tag == 0 {
            resourceChoice = .blog
        } else {
            resourceChoice = .video
        }
        let vc = storyboard?.instantiateViewController(identifier: "allResourcesViewController")
        let navController = UINavigationController(rootViewController: vc!)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Category.allCases[indexPath.section] == .book {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "BooksCell") as? BooksTableViewCell)!
            cell.books = currentResources.filter({Category(rawValue: $0.category ?? "") == .book})
            cell.collectionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? ResourceTableViewCell
//            return resources.filter({$0.category == Category.allCases[section]}).count
            let resource = currentResources.filter({Category(rawValue: $0.category ?? "") == Category.allCases[indexPath.section]})[indexPath.row]
            
            cell?.titleLabel.text = resource.title
            cell?.descriptionLabel.text = resource.subtitle
            if let imageUrlString = resource.imageUrl, let imageUrl = URL(string: imageUrlString) {
                cell?.headerImageView.hnk_setImageFromURL(imageUrl)
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resource = currentResources.filter({Category(rawValue: $0.category ?? "") == Category.allCases[indexPath.section]})[indexPath.row]
        
        if let resourceUrlString = resource.actionUrl, let resourceUrl = URL(string: resourceUrlString) {
            present(SFSafariViewController(url: resourceUrl), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.tintColor = .secondarySystemBackground
        
        let label = UILabel(frame: CGRect(x: 25, y: 10, width: view.frame.width - 32, height: 30))
        label.text = Category.allCases[section].rawValue.capitalizingFirstLetter()
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(label)
        return headerView
    }
}
