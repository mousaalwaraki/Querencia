//
//  DayViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import CoreData

class DayViewController: UIViewController {
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var smileyCollectionView: UICollectionView!
    @IBOutlet weak var motivationalQuoteCard: UIView!
    @IBOutlet weak var smileyView: UIView!
    @IBOutlet weak var journalButtonView: UIView!
    @IBOutlet weak var bgCollectionView: UIView!
    @IBOutlet weak var quoteText: UILabel!
    
    var allTags = ["Went on a run! 🏃‍♂️", "Ate healthy! 🥦🙆‍♀️", "Ate junk food 🍟😣", "Did some work 💻", "Spent some family time! 👨‍👩‍👧‍👧", "Spent too much time on my phone 📱", "Went on a cruise 🚘", "Spent time with my friends 👯‍♂️", "Played football ⚽️", "Meditated 🧘", "Went on a bike ride 🚴‍♂️", "Worked out! 🏋️‍♀️", "Did yoga 🤸‍♀️", "Went to the beach 🏝"]
    var selectedTags = [String]()
    var smileys = ["😁","🙂","😐","🙁","☹️"]
    var color: UIColor?
    var journals = [JournalModel]()
    var journalEntry: UserResponses?
    var combinedCurrentDate = ""
    var moodSelected: Int16?
    var quotes = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        getTodaysDate()
        
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            let entries = returnedArray as! [UserResponses]
            for entry in entries {
                if entry.date == combinedCurrentDate {
                    journalEntry = entry
                    selectedTags = entry.dayTags ?? []
                    moodSelected = entry.dayFeeling
                }
            }
        }
        
        CoreDataManager().load("UserTags") { [self] (returnedArray: [NSManagedObject]) in
            if returnedArray.count == 0 {
                CoreDataManager().saveUserTags(allTags)
            } else {
                let savedTags = returnedArray[0] as? UserTags
                allTags = (savedTags?.allTags)!
                for tag in selectedTags {
                    if allTags.contains(tag) {
                        allTags.removeAll(where: {$0 == tag})
                        allTags.insert(tag, at: 0)
                    }
                }
                tagsCollectionView.reloadData()
            }
        }
        
        CoreDataManager().load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            if returnedArray.count == 0 {
                setJournals()
            } else {
                journals.removeAll()
                let savedJournals = returnedArray as! [UserJournals]
                for journal in savedJournals {
                    let userTitle = journal.userTitle
                    let title = journal.title
                    let questions = journal.questions
                    if questions?.count == 0 { return }
                    journals.append(JournalModel(userTitle: userTitle, title: title, questions: questions))
                }
            }
        }
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        smileyCollectionView.delegate = self
        smileyCollectionView.dataSource = self
        
        setCollectionViewCell()
        setMotivationalQuote()
        
        motivationalQuoteCard.setCard()
        smileyView.setCard()
        journalButtonView.setCard()
        bgCollectionView.setCard()
    }
    
    
    
    @IBAction func journalButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Journal Choice", message: "Which of your journals would you like to write to today?", preferredStyle: .actionSheet)
        for journal in journals {
            alert.addAction(UIAlertAction(title: journal.userTitle, style: .default) { _ in
                let vc = JournalResponseViewController()
                vc.chosenJournal = journal
                vc.number = 0
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func setMotivationalQuote() {
        if quotes.count == 0 {
            resetQuotes()
        }
        let randomQuote = Int(arc4random_uniform(UInt32(quotes.count)))
        quoteText.text = quotes[randomQuote]
        quotes.remove(at: randomQuote)
    }
    
    func setCollectionViewCell() {
        let cellSize = CGSize(width:(self.view.frame.width/5) - 13 , height:40)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        smileyCollectionView.setCollectionViewLayout(layout, animated: true)
        
        smileyCollectionView.reloadData()
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
    
    func saveToCoreData() {
        CoreDataManager().save(combinedCurrentDate, moodSelected ?? 100, journalEntry?.dayQuestions ?? [], journalEntry?.dayResponses ?? [], selectedTags, journalEntry?.journalName ?? "")
    }
}

extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionTitlesCollectionReusableView {
            
            let label = sectionHeader.labelText
            let headerView = sectionHeader.headerView
            
            headerView?.tintColor = .secondarySystemBackground
            
            label?.text = "Day Activities"
            label?.textColor = .secondaryLabel
            label?.font = UIFont.boldSystemFont(ofSize: 14)
            
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagsCollectionView {
            return allTags.count
        } else {
            return smileys.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
            
            cell.tagLabel.text = allTags[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 8
            
            if selectedTags.contains(allTags[indexPath.row]) == true {
                cell.backgroundColor = .whatsNewKitRed
                cell.tagLabel.textColor = .whatsNewKitWhite
                cell.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
                
            } else {
                cell.layer.borderColor = UIColor.whatsNewKitRed.cgColor
                cell.tagLabel.textColor = .whatsNewKitRed
                cell.backgroundColor = .clear
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smileyCell", for: indexPath) as! SmileyCollectionViewCell
            cell.smileyLabel.text = smileys[indexPath.row]
            if indexPath.row == Int(moodSelected ?? 100) {
                cell.bgView.backgroundColor = .whatsNewKitRed
                cell.bgView.layer.cornerRadius = cell.bgView.frame.width/2
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            let tag = indexPath.row
            let cell = tagsCollectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as? TagsCollectionViewCell
            if cell?.tagLabel.textColor == .whatsNewKitRed {
                cell?.backgroundColor = .whatsNewKitRed
                cell?.tagLabel.textColor = .whatsNewKitWhite
                selectedTags.append(cell?.tagLabel.text! ?? "")
                
                let tagToMove = allTags[tag]
                allTags.remove(at: tag)
                allTags.insert(tagToMove, at: 0)
                let tagsIndexPath = IndexPath(row: 0, section: 0)
                tagsCollectionView.moveItem(at: IndexPath(row: tag, section: 0), to: tagsIndexPath)
            } else {
                cell?.backgroundColor = .clear
                cell?.layer.borderColor = UIColor.whatsNewKitRed.cgColor
                cell?.tagLabel.textColor = .whatsNewKitRed
                selectedTags.removeAll { $0 == (cell?.tagLabel.text!)}
                
                let tagToMove = allTags[tag]
                allTags.remove(at: tag)
                allTags.insert(tagToMove, at: selectedTags.count)
                let tagsIndexPath = IndexPath(row: selectedTags.count, section: 0)
                tagsCollectionView.moveItem(at: IndexPath(row: tag, section: 0), to: tagsIndexPath)
            }
            saveToCoreData()
        } else {
            for smiley in 0...smileys.count - 1 {
                let cell = smileyCollectionView.cellForItem(at: IndexPath(row: smiley, section: 0)) as! SmileyCollectionViewCell
                if smiley == indexPath.row && cell.bgView.backgroundColor != .whatsNewKitRed {
                    cell.bgView.backgroundColor = .whatsNewKitRed
                    cell.bgView.layer.cornerRadius = cell.bgView.frame.width/2
                    moodSelected = Int16(indexPath.row)
                } else { cell.bgView.backgroundColor = .clear }
            }
            saveToCoreData()
        }
    }
}

extension DayViewController {
    func setJournals() {
        CoreDataManager().saveUserJournals("Open", "Journal1", ["Write down your thoughts on the day or simply too record what happened in your day!"])
        CoreDataManager().saveUserJournals("Gratitude", "Journal2", ["Write about 1 person in your life that you are grateful for and why.", "What is a skill or ability you have that you are thankful for?", "What about you or your day do you not notice that you can be thankful for?"])
        CoreDataManager().saveUserJournals("Reflection", "Journal3", ["Recall an event, a thought, or something about yourself that’s on your mind.", "Why do you think it happened and what did it mean to you?", "What can you learn from this? Any lessons that can be learnt?"])
        CoreDataManager().saveUserJournals("Problem Solving", "Journal4", ["What is a problem you’ve been facing recently that you’d like to solve?", "Can you break down the problem to a deeper level?", "What are some simple steps you can do to tackle the root causes of the problem and help tackle it?"])
        CoreDataManager().saveUserJournals("Goal Setting", "Journal5", ["Write down a goal you want to accomplish over the next year, make it specific and measurable.", "Why do you want to achieve it?", "What steps are necessary to achieve it?"])
        CoreDataManager().saveUserJournals("My Journal", "Journal 6", ["Did I get angry today? Why?","What did I do wrong today?","What did I do right today?","What could I have done differently?","What made today great?", "What did I work on/learn today?", "Any extra thoughts on the day?"])
        CoreDataManager().load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            let savedJournals = returnedArray as! [UserJournals]
            for journal in savedJournals {
                let userTitle = journal.userTitle
                let title = journal.title
                let questions = journal.questions
                journals.append(JournalModel(userTitle: userTitle, title: title, questions: questions))
            }
        }
    }
    
    func resetQuotes() {
        quotes = ["“There’s simply no better way to learn about your thought processes than to write them down.“ - Barbara Markway", "“Journal writing is a voyage to the interior.“ - Christina Baldwin","“The habit of writing for my eye is good practice. It loosens the ligaments.“ - Virginia Woolf", "“This pouring thoughts out on paper has relieved me. I feel better and full of confidence and resolution.“ - Diet Eman", "“Journal writing gives us insights into who we are, who we were, and who we can become.“ - Sandra Marinella", "“When I look back on my personal story through my journals, it struck me my words had an unmatched power to heal me. To change me.“ - Sandra Marinella","“You must remember that your story matters. What you write has the power to save a life, sometimes that life is your own.“ - Stalina Goodwin","“Journaling can be an excellent way to increase self-awareness, discover and change habits.“ - Akiroq Brost", "“Documenting little details of your everyday life becomes a celebration of who you are.“ - Carolyn V. Hamilton", "“These empty pages are your future, soon to become your past. T will read the most personal tale you shall ever find in a book.“ - Anon","“He captures memories because if he forgets them, it's as though they didn't happen.“ - Donald Miller", "“Successful journals break the deadlock of introspective obsession.“ - Alexandra Johnson","“The pages afforded glimpses into my soul where I'd hidden it, behind masks of paper and ink.“ - Rachel Schade","“I journal my joy, and my joy expands exponentially forevermore. So be it.“ - Amy Mercree","“Writing is the only way I have to explain my own life to myself.“ - Pat Conroy", "“Journaling is like whispering to one’s self and listening at the same time.“ - Mina Murray", "“People who keep journals have life twice.“ - Jessamyn West","“Keeping a journal of what’s going on in your life is a good way to help you distill what’s important and what’s not.“ - Martina Navratilova","“In the journal I do not just express myself more openly than I could to any person; I create myself.“ - Susan Sontag","“I can shake off everything as I write; my sorrows disappear, my courage is reborn.“ - Anne Frank","“Journal writing, when it becomes a ritual for transformation, is not only life-changing but life-expanding.“ - Jen Williamson","“I love my journal as much as I love my phone. I find it to be a big part of my self-care to reflect on my day and write words that inspire me.“ - Franchesca Ramsey","“Journaling is paying attention to the inside for the purpose of living well from the inside out.“ - Lee Wise","“A journal is your completely unaltered voice.“ - Lucy Dacus","“As there are a thousand thoughts lying within a man that he does not know till he takes up the pen to write.“ - William Thackeray","“When I look back on my personal story through my journals, it struck me my words had an unmatched power to heal me. To change me.“ - Sandra Marinella","“Journal writing gives us insights into who we are, who we were, and who we can become.“ - Sandra Marinella"]
    }
}
