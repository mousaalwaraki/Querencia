//
//  SettingsViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import CoreData
import MessageUI
import HintPod
import LocalAuthentication
import SafariServices

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    var previewItem: NSURL?
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    var sections: [(String, [SettingsItem])] = []
    let context:LAContext = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(("Configuration", [.password, .editJournals, .editTags, .notifications]))
        sections.append(("Privacy", [.terms, .mission]))
        sections.append(("Spread the love", [.contact, .share, .suggestFeature]))
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.reloadData()
        profileTableView.tableFooterView = UIView()
        backgroundView.backgroundColor = .secondarySystemBackground
                
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsTableViewCell
        let item = sections[indexPath.section].1[indexPath.row]
        cell.setup(with: item)
        if item == .password {
            cell.selectionStyle = .none
            cell.accessoryType = .none
            
            cell.settingsSwitch.isHidden = false
            if item == .password {
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error:nil) {
                    cell.settingsSwitch.isEnabled = true
                } else {
                    cell.settingsSwitch.isOn = false
                    cell.settingsSwitch.isEnabled = false
                    UserDefaults.standard.set(false, forKey: "Password")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.tintColor = .secondarySystemBackground
        
        let label = UILabel(frame: CGRect(x: 25, y: 10, width: view.frame.width - 32, height: 30))
        label.text = sections[section].0
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section].1[indexPath.row] {
        case .editJournals:
            presentEditJournals()
        case .terms:
            showPrivacyAndTerms()
        case .mission:
            tappedMission()
        case .contact:
            tappedContact()
        case .share:
            tappedShare()
        case .signOut:
            tappedSignOut()
        case .suggestFeature:
            tappedFeature()
        case .notifications:
            tappedNotifications()
        case .password:
            break
        case .addResources:
            addResources()
        case .editTags:
            editTags()
        }
    }
    
    func editTags() {
        let vc = storyboard?.instantiateViewController(identifier: "EditActivityViewController")
        navigationController?.pushViewController(vc!, animated: true)    }
    
    func presentEditJournals() {
        let vc = storyboard?.instantiateViewController(identifier: "EditJournalsViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func addResources() {
        let vc = storyboard?.instantiateViewController(identifier: "AddingResourcesViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tappedNotifications() {
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedSignOut() {
    }
    
    func tappedFeature() {
        HintPod.present(title: "Suggest A Feature")
    }
    
    func showPrivacyAndTerms() {
        openUrl(urlString: "https://getterms.io/g/?product_name=JournalSimple&name=JournalSimple&location=UK&effective_date=17+May+2020&language=en-au")
    }
    
    func tappedMission() {
        let vc = AboutVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedShare() {
        guard let url = URL(string: "https://apps.apple.com/gb/app/querencia/id1512500064") else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func tappedContact() {
        let alert = UIAlertController(title: "Contact Me", message: "I love hearing from you! If you give me a shout on any of the platforms below I'll be quick to answer.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Twitter", style: .default, handler: { (action) in
            self.openTwitter()
        }))
        alert.addAction(UIAlertAction(title: "iMessage", style: .default, handler: { (action) in
            self.sendMessage()
        }))
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
            self.sendEmail()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        self.present(alert, animated: true)
    }
    
    func openTwitter() {
        var url = ""
        let appURL = "twitter:///user?screen_name=mousaalwaraki"
        let webURL = "https://twitter.com/mousaalwaraki"
        let application = UIApplication.shared
        if application.canOpenURL(URL(string: appURL)!) {
            url = appURL
        } else {
            url = webURL
        }
        openUrl(urlString: url)
    }
    
    func sendMessage() {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.recipients = ["mousa.alwaraki@gmail.com"]
            present(messageComposeViewController, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mousa.alwaraki@gmail.com"])
            mail.setSubject("Querencia")
            present(mail, animated: true)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol SettingsItemDelegate {
    func tappedMission()
    func showPrivacyAndTerms()
}

enum SettingsItem: CaseIterable {
    case editJournals
    case terms
    case mission
    case contact
    case share
    case signOut
    case suggestFeature
    case notifications
    case password
    case addResources
    case editTags
}

extension SettingsItem {
    
    var title: String {
        switch self {
        case .editJournals:
            return "Edit Journals"
        case .notifications:
            return "Notifications"
        case .terms:
            return "Your privacy"
        case .mission:
            return "Our mission"
        case .contact:
            return "Get in touch"
        case .share:
            return "Share Querencia"
        case .signOut:
            return "Sign Out"
        case .suggestFeature:
            return "Suggest a feature"
        case .password:
            return "Password"
        case .addResources:
            return "Add Resource"
        case .editTags:
            return "Edit Activities"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .editJournals:
            return UIImage(systemName: "questionmark.square.fill")
        case .terms:
            return UIImage(systemName: "hand.raised.slash.fill")
        case .mission:
            return UIImage(systemName: "heart.fill")
        case .contact:
            return UIImage(systemName: "envelope.fill")
        case .share:
            return UIImage(systemName: "square.and.arrow.up.fill")
        case .signOut:
            return UIImage(systemName: "bookmark.fill")
        case .suggestFeature:
            return UIImage(systemName: "smiley.fill")
        case .notifications:
            return UIImage(systemName: "rosette")
        case .password:
            return UIImage(systemName: "lock")
        case .addResources:
            return UIImage(systemName: "plus")
        case .editTags:
            return UIImage(systemName: "pencil")
        }
    }
    
    var color: UIColor {
        switch self {
        case .editJournals:
            return .systemYellow
        case .terms:
            return .systemOrange
        case .mission:
            return .systemRed
        case .contact:
            return .systemBlue
        case .share:
            return .systemGreen
        case .signOut:
            return .systemGray
        case .suggestFeature:
            return .systemYellow
        case .notifications:
            return .purple
        case .password:
            return .systemRed
        case .addResources:
            return .whatsNewKitPurple
        case .editTags:
            return .whatsNewKitPurple
        }
    }
}
