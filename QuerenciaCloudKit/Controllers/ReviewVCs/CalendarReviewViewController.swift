//
//  CalendarReviewViewController.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import FSCalendar
import CoreData
import Charts

class CalendarReviewViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var addDataLabel: UILabel!
    @IBOutlet weak var historyTagsCollectionView: UICollectionView!
    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dayRatedLabel: UILabel!
    @IBOutlet weak var alertPopUpView: UIView!
    @IBOutlet weak var seeJournalEntries: UIButton!
    @IBOutlet weak var datePickerStack: UIStackView!
    
    @IBOutlet weak var reviewBySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var moodToFilterBy: UIView!
    @IBOutlet weak var topTagsTable: UITableView!
    @IBOutlet weak var topTagsCollectiionView: UICollectionView!
    @IBOutlet weak var moodCollectionView: UICollectionView!
    
    @IBOutlet weak var tagsTagCollectionContainingView: UIView!
    @IBOutlet weak var horizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    
    var heightConstraintDatePicker: NSLayoutConstraint!
    var allDays : [String] = []
    var combinedDate = Date()
    var combinedCurrentDate: String?
    var entries: [UserResponses]?
    var rating: RatingSwitch?
    var tags = [String]()
    var entry: UserResponses?
    var pickedCombinedCurrentDate = ""
    var smileys = ["😁","🙂","😐","🙁","☹️"]
    var moodEntries: [UserResponses]?
    var options: [Option]!
    var responses = [UserResponses]()
    var tagsTag = [String]()
    var chosenTag: String?
    var promptsReviewArray = [PromptsReview]()
    var repeatedTags = [String]()
    var array = [String]()
    var selected: Int?
    var activitesTag = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        
        styleSegmentedControl()
        
        removeAllSetup()
        horizontalBarChart.noDataText = "Pick an activity to get mood data!"
        
        heightConstraintDatePicker = NSLayoutConstraint(item: datePicker!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0)
        heightConstraintDatePicker.isActive = true
        
        setUpMood()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tags.removeAll()
        repeatedTags.removeAll()
        moodEntries?.removeAll()
        activitesTag.removeAll()
        entries?.removeAll()
        chosenTag = nil
        horizontalBarChart.data = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CoreDataManager().load("UserTags") { [self] (returnedArray: [NSManagedObject]) in
            let allTags = returnedArray[0] as! UserTags
            tagsTag = allTags.allTags ?? []
        }
        
        
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            responses = returnedArray as! [UserResponses]
        }
        
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            moodEntries = returnedArray as? [UserResponses]
            entries = returnedArray as? [UserResponses]
            for entry in entries ?? [] {
                allDays.append(entry.date!)
            }
            for entry in entries ?? [] {
                for tag in tagsTag {
                    if entry.dayTags?.contains(tag) == true && activitesTag.contains(tag) == false {
                        activitesTag.append(tag)
                    }
                }
            }
            getTodaysDate()
            getResults(at: combinedCurrentDate!)
            calendar.select(combinedDate)
            activitiesCollectionView.reloadData()
        }
        
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            moodEntries = returnedArray as? [UserResponses] ?? []
            for entry in moodEntries ?? [] {
                if entry.dayFeeling == selected ?? 999 {
                    for tag in entry.dayTags ?? [] {
                        repeatedTags.append(tag)
                    }
                }
            }
            getPrompts()
        }
    }
    
    func removeAllSetup() {
        addDataLabel.alpha = 0
        historyTagsCollectionView.alpha = 0
        viewForBackground.alpha = 0
        calendar.alpha = 0
        dayRatedLabel.alpha = 0
        alertPopUpView.alpha = 0
        seeJournalEntries.alpha = 0
        datePickerStack.alpha = 0
                
        moodToFilterBy.alpha = 0
        topTagsTable.alpha = 0
        topTagsCollectiionView.alpha = 0
        moodCollectionView.alpha = 0
        
        horizontalBarChart.alpha = 0
        activitiesCollectionView.alpha = 0
        tagsTagCollectionContainingView.alpha = 0
        
        addDataLabel.text = "Rate your day and add activities to be able to analyse your data!"
        
        horizontalBarChart.data = nil
        tags.removeAll()
        chosenTag = nil
        repeatedTags.removeAll()
        selected = nil
        promptsReviewArray.removeAll()
        array.removeAll()
    }
    
    func setUpMood() {
        moodToFilterBy.alpha = 1
        moodCollectionView.alpha = 1
        showTopTagsTable(0)
        showTopTagsCollectionView(0)
        view.layoutIfNeeded()
        
        moodCollectionView.reloadData()
        topTagsCollectiionView.reloadData()
        topTagsTable.reloadData()
        
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
        topTagsCollectiionView.delegate = self
        topTagsCollectiionView.dataSource = self
        topTagsTable.delegate = self
        topTagsTable.dataSource = self
        
        getPrompts()
        moodToFilterBy.setCard()
        topTagsCollectiionView.setCard()
        topTagsTable.setCard()
        setCollectionViewCell()
    }
    
    func setUpTags() {
        horizontalBarChart.alpha = 1
        activitiesCollectionView.alpha = 1
        tagsTagCollectionContainingView.alpha = 1
        
        activitiesCollectionView.reloadData()
        
        activitiesCollectionView.delegate = self
        activitiesCollectionView.dataSource = self
        horizontalBarChart.delegate = self
        
        tagsTagCollectionContainingView.setCard()
    }
    
    func setUpHistroy() {
        historyTagsCollectionView.alpha = 1
        calendar.alpha = 1
        dayRatedLabel.alpha = 1
        seeJournalEntries.alpha = 1
        datePickerStack.alpha = 1
        
        alertPopUpView.setCard()
        heightConstraintDatePicker = NSLayoutConstraint(item: datePicker!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0)
        heightConstraintDatePicker.isActive = true
        
        calendar.delegate = self
        calendar.dataSource = self
        historyTagsCollectionView.delegate = self
        historyTagsCollectionView.dataSource = self
        
        getTodaysDate()
        getResults(at: combinedCurrentDate!)
        calendar.reloadData()
        pickedCombinedCurrentDate = combinedCurrentDate!
    }
    
    func styleSegmentedControl() {
        reviewBySegmentedControl.selectedSegmentTintColor = .whatsNewKitWhite
        reviewBySegmentedControl.backgroundColor = .whatsNewKitRed
        reviewBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.whatsNewKitRed], for: .selected)
        reviewBySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.whatsNewKitWhite], for: .normal)
    }
    
    func getPrompts() {
        promptsReviewArray.removeAll()
        array.removeAll()
        if repeatedTags.count == 0 {
            topTagsTable.reloadData()
            topTagsCollectiionView.reloadData()
            return
        }
        for tag in repeatedTags {
            if array.contains(tag) == false {
                let count = repeatedTags.filter{$0 == tag}.count
                promptsReviewArray.append(PromptsReview(prompt: tag, count: count))
                array.append(tag)
            } else {
                guard let index = promptsReviewArray.firstIndex(where: {$0.prompt == tag}) else { return }
                promptsReviewArray[index].count! += 1
            }
        }
        promptsReviewArray.sort(by: {$0.count! > $1.count!})
        array.removeAll()
        var number = Int()
        if promptsReviewArray.count < 3 { number = promptsReviewArray.count - 1 } else { number = 2 }
        for _ in 0...number {
            array.append(promptsReviewArray[0].prompt!)
            promptsReviewArray.remove(at: 0)
        }
        topTagsTable.reloadData()
        topTagsCollectiionView.reloadData()
    }
    
    @IBAction func tapOnBgView(_ sender: Any) {
        if viewForBackground.alpha == 0 {
            return
        } else {
            self.heightConstraintDatePicker.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func jumpToDateButtonTapped(_ sender: Any) {
        if self.heightConstraintDatePicker.constant == 0 {
            datePicker.backgroundColor = .secondarySystemBackground
            datePicker.clipsToBounds = true
            self.heightConstraintDatePicker.constant = 216
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0.5
                self.view.layoutIfNeeded()
            }
            datePicker.layer.cornerRadius = 20
            datePicker.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            return
        } else if self.heightConstraintDatePicker.constant == 216 {
            self.heightConstraintDatePicker.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.viewForBackground.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func todayButtonTapped(_ sender: Any) {
        getTodaysDate()
        getResults(at: combinedCurrentDate!)
        calendar.select(combinedDate)
        datePicker.setDate(combinedDate, animated: false)
        historyTagsCollectionView.reloadData()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.yyyy"
        pickedCombinedCurrentDate = formatter.string(from: datePicker.date)
        
        getResults(at: pickedCombinedCurrentDate)
        // Refresh rating and tags
        let chosenDate = formatter.date(from: pickedCombinedCurrentDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: chosenDate!)
        let finalDate = calendar.date(from:components)
        self.calendar.select(finalDate)
    }
    
    @IBAction func reviewJournal(_ sender: Any) {
        if entry?.journalName == "" || entry?.journalName == nil {
            UIView.animate(withDuration: 0.3) {
                self.alertPopUpView.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.3) {
                        self.alertPopUpView.alpha = 0
                    }
                }
            }
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "ReviewJournalViewController") as? ReviewJournalViewController
            vc?.journalTitle = entry?.journalName
            vc?.chosenDate = pickedCombinedCurrentDate
            present(vc!, animated: true)
        }
    }
    
    @IBAction func reviewByIndexChanged(_ sender: Any) {
        removeAllSetup()
        if reviewBySegmentedControl.selectedSegmentIndex == 0 {
            setUpMood()
        } else if reviewBySegmentedControl.selectedSegmentIndex == 1 {
            setUpTags()
        } else {
            setUpHistroy()
        }
    }

    
    func getResults(at date: String) {
        for entry in entries ?? [] {
            if entry.date == date {
                self.entry = entry
                setResults(entry)
                return
            }
        }
        rating = RatingSwitch.none
        dayRatedLabel.text = rating?.getTextLabel()
        tags = []
        historyTagsCollectionView.reloadData()
        
    }
    
    func setResults(_ entry: UserResponses) {
        if entry.dayFeeling == 0 {
            rating = .vHappy
        } else if entry.dayFeeling == 1 {
            rating = .happy
        } else if entry.dayFeeling == 2 {
            rating = .ok
        } else if entry.dayFeeling == 3 {
            rating = .sad
        } else if entry.dayFeeling == 4 {
            rating = .vSad
        } else {
            rating = RatingSwitch.none
        }
        dayRatedLabel.text = rating?.getTextLabel()
        tags = entry.dayTags ?? []
        
        historyTagsCollectionView.reloadData()
    }
    
    func runUpdateCells() {
        for tag in 0...activitesTag.count - 1 {
            let cell = activitiesCollectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as! ActivitiesCollectionViewCell
            if cell.activitiesLabel.text == chosenTag {
                cell.backgroundColor = .whatsNewKitRed
                cell.activitiesLabel.textColor = .whatsNewKitWhite
                cell.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
            } else {
                cell.backgroundColor = .clear
                cell.layer.borderColor = UIColor.whatsNewKitRed.cgColor
                cell.activitiesLabel.textColor = .whatsNewKitRed
            }
        }
    }
    
    func setCollectionViewCell() {
        let cellSize = CGSize(width:(self.view.frame.width/5) - 13 , height:40)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        moodCollectionView.setCollectionViewLayout(layout, animated: true)
        
        moodCollectionView.reloadData()
    }
    
    func showTopTagsTable(_ alpha: Int) {
        UIView.animate(withDuration: 0.3) { [self] in
            topTagsTable.alpha = CGFloat(alpha)
        }
    }
    
    func showTopTagsCollectionView(_ alpha: Int) {
        UIView.animate(withDuration: 0.3) { [self] in
            topTagsCollectiionView.alpha = CGFloat(alpha)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"
        let dateString = formatter.string(from: date)
        if allDays.contains(dateString) {
            return 1
        }
        return 0
    }}

extension CalendarReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionTitlesCollectionReusableView {
            
            let label = sectionHeader.labelText
            let headerView = sectionHeader.headerView
            
            headerView?.tintColor = .secondarySystemBackground
            
            if collectionView == activitiesCollectionView {
                label?.text = "Pick an activity to filter by"
            } else {
                label?.text = "Rest of activities (in ascending order)"
                if promptsReviewArray.count > 0 { label?.alpha = 1 } else { label?.alpha = 0}
            }
            label?.textColor = .secondaryLabel
            label?.font = UIFont.boldSystemFont(ofSize: 14)
            headerView?.layer.cornerRadius = 12
            headerView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == historyTagsCollectionView {
            return tags.count
        } else if collectionView == activitiesCollectionView {
            if reviewBySegmentedControl.selectedSegmentIndex == 1 {
                if activitesTag.count == 0 { activitiesCollectionView.alpha = 0; horizontalBarChart.alpha = 0; addDataLabel.alpha = 1; tagsTagCollectionContainingView.alpha = 0} else { activitiesCollectionView.alpha = 1; horizontalBarChart.alpha = 1; addDataLabel.alpha = 0; tagsTagCollectionContainingView.alpha = 1 }}
            return activitesTag.count
        } else if collectionView == moodCollectionView {
            if reviewBySegmentedControl.selectedSegmentIndex == 0 {
                if entries?.count == 0 { moodToFilterBy.alpha = 0 } else { moodToFilterBy.alpha = 1 }
                if entries?.count == 0 && promptsReviewArray.count == 0 { addDataLabel.text = "Rate your day and add activities to be able to analyse your data!"} else if selected != nil { addDataLabel.text = "No activities for this mood."} else { addDataLabel.text = "Pick a mood to see the most tagged activities!" }
            }
            return smileys.count
        } else {
            if reviewBySegmentedControl.selectedSegmentIndex == 0 {
                if promptsReviewArray.count == 0 {showTopTagsCollectionView(0); addDataLabel.alpha = 1} else {showTopTagsCollectionView(1); addDataLabel.alpha = 0}}
            return promptsReviewArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == historyTagsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsReview", for: indexPath) as! TagsCollectionViewCell
            
            cell.tagLabel.text = tags[indexPath.row]
            cell.backgroundColor = .whatsNewKitRed
            cell.tagLabel.textColor = .whatsNewKitWhite
            cell.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 8
            
            return cell
        } else if collectionView == activitiesCollectionView {
            let cell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivitiesCollectionViewCell
            cell.activitiesLabel.text = activitesTag[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 8
            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.whatsNewKitRed.cgColor
            cell.activitiesLabel.textColor = .whatsNewKitRed
            if chosenTag == activitesTag[indexPath.row] {
                cell.backgroundColor = .whatsNewKitRed
                cell.activitiesLabel.textColor = .whatsNewKitWhite
                cell.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
                activitiesCollectionView.reloadData()
            }
            return cell
        } else  if collectionView == moodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smileyCell", for: indexPath) as! SmileyCollectionViewCell
            cell.smileyLabel.text = smileys[indexPath.row]
            if selected == indexPath.row {
                cell.bgView.backgroundColor = .whatsNewKitRed
                cell.bgView.layer.cornerRadius = cell.bgView.frame.width/2
            } else {
                cell.bgView.backgroundColor = .clear
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagsCollectionViewCell
            cell.layer.borderColor = UIColor.whatsNewKitRed.cgColor
            cell.tagLabel.text = promptsReviewArray[indexPath.row].prompt
            cell.tagLabel.textColor = .whatsNewKitRed
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 8
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moodCollectionView {
            let cell = moodCollectionView.cellForItem(at: indexPath) as! SmileyCollectionViewCell
            for smiley in 0...smileys.count - 1 {
                let clearCell = moodCollectionView.cellForItem(at: IndexPath(row: smiley, section: 0)) as! SmileyCollectionViewCell
                clearCell.bgView.backgroundColor = .clear
            }
            if cell.bgView.backgroundColor != .whatsNewKitRed {
                cell.bgView.backgroundColor = .whatsNewKitRed
                cell.bgView.layer.cornerRadius = cell.bgView.frame.width/2
                selected = indexPath.row
                addDataLabel.text = "No activities for this mood."
            } else {
                cell.bgView.backgroundColor = .clear
                selected = nil
            }
            repeatedTags.removeAll()
            moodEntries?.removeAll()
            CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
                moodEntries = returnedArray as? [UserResponses] ?? []
                for entry in moodEntries ?? [] {
                    if entry.dayFeeling == selected ?? 999 {
                        for tag in entry.dayTags ?? [] {
                            repeatedTags.append(tag)
                        }
                    }
                }
                getPrompts()
            }
        } else if collectionView == activitiesCollectionView {
            let cell = activitiesCollectionView.cellForItem(at: indexPath) as! ActivitiesCollectionViewCell
            if cell.activitiesLabel.text != chosenTag {
                chosenTag = activitesTag[indexPath.row]
                cell.activitiesLabel.textColor = .whatsNewKitWhite
                cell.backgroundColor = .whatsNewKitRed
                cell.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
                let tagToMove = activitesTag[indexPath.row]
                activitesTag.remove(at: indexPath.row)
                activitesTag.insert(tagToMove, at: 0)
                
                let tagsIndexPath = IndexPath(item: 0, section: 0)
                activitiesCollectionView.moveItem(at: indexPath, to: tagsIndexPath)
                runUpdateCells()
                activitiesCollectionView.reloadData()
            }
            
            setUpBarChart()
        }
    }
    
}

extension CalendarReviewViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        let pickedCombinedDate = calendar.date(from:components)!
        pickedCombinedCurrentDate = formatter.string(from: pickedCombinedDate)
        getResults(at: pickedCombinedCurrentDate)
        datePicker.setDate(date, animated: false)
    }
    
    func getTodaysDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        combinedDate = calendar.date(from:components)!
        combinedCurrentDate = formatter.string(from: combinedDate)
    }
}

extension CalendarReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count == 0 {showTopTagsTable(0)} else {showTopTagsTable(1)}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topTagCell", for: indexPath) as! TopTagTableViewCell
        cell.topPromptImage.image = UIImage(named: "\(indexPath.row + 1)")
        cell.topPromptLabel.text = " " + array[indexPath.row] + " "
        cell.topPromptLabel.layer.backgroundColor = UIColor.whatsNewKitRed.cgColor
        cell.topPromptLabel.layer.borderColor = UIColor.whatsNewKitBlack.cgColor
        cell.topPromptLabel.layer.borderWidth = 0.5
        cell.topPromptLabel.layer.cornerRadius = 8
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if indexPath.row == 2 {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        cell.topPromptLabel.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height/CGFloat(array.count)
    }
}

extension CalendarReviewViewController: ChartViewDelegate {
    
    func setUpBarChart() {
        var entries = [BarChartDataEntry]()
        for smiley in 0...smileys.count - 1 {
            var number = 0.0
            for response in responses {
                if response.dayTags?.contains(chosenTag ?? "") == true && response.dayFeeling == smiley {
                    number += 1
                }
            }
            let entry = BarChartDataEntry(x: Double(smiley), y: number)
            entries.append(entry)
        }
        
        var zeroValues = 0
        
        for entry in entries {
            if entry.y == 0 {
                zeroValues += 1
            }
        }
        if zeroValues == 5 {
            horizontalBarChart.data = nil
        }
        
        horizontalBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: smileys)
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.valueFont = UIFont(name: "Avenir Next", size: 13.0)!
        dataSet.valueColors = [.whatsNewKitWhite]
        dataSet.colors = [.whatsNewKitRed]
        let data = BarChartData(dataSets: [dataSet])
        data.barWidth = 0.6
        
        setUpBarChartStyle()
        
        horizontalBarChart.data = data
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .none
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        formatter.percentSymbol = ""
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
    }
    
    func setUpBarChartStyle() {
        horizontalBarChart.alpha = 1
        horizontalBarChart.legend.enabled = false
        
        self.options = [.toggleValues,
                        .toggleIcons,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        horizontalBarChart.animate(yAxisDuration: 1.5)
        
        let xAxis = horizontalBarChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 15)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.granularity = 1
        
        let leftAxis = horizontalBarChart.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 1
        
        let rightAxis = horizontalBarChart.rightAxis
        rightAxis.labelPosition = .outsideChart
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.granularity = 1
        
        horizontalBarChart.drawValueAboveBarEnabled = false
    }
    
    enum Option {
        case toggleValues
        case toggleIcons
        case toggleHighlight
        case animateX
        case animateY
        case animateXY
        case saveToGallery
        case togglePinchZoom
        case toggleAutoScaleMinMax
        case toggleData
        case toggleBarBorders
        // LineChart
        case toggleGradientLine
        // CandleChart
        case toggleShadowColorSameAsCandle
        case toggleShowCandleBar
        // CombinedChart
        case toggleLineValues
        case toggleBarValues
        case removeDataSet
        // CubicLineSampleFillFormatter
        case toggleFilled
        case toggleCircles
        case toggleCubic
        case toggleHorizontalCubic
        case toggleStepped
        // HalfPieChartController
        case toggleXValues
        case togglePercent
        case toggleHole
        case spin
        case drawCenter
        case toggleLabelsMinimumAngle
        // RadarChart
        case toggleXLabels
        case toggleYLabels
        case toggleRotate
        case toggleHighlightCircle
        
        var label: String {
            switch self {
            case .toggleValues: return "Toggle Y-Values"
            case .toggleIcons: return "Toggle Icons"
            case .toggleHighlight: return "Toggle Highlight"
            case .animateX: return "Animate X"
            case .animateY: return "Animate Y"
            case .animateXY: return "Animate XY"
            case .saveToGallery: return "Save to Camera Roll"
            case .togglePinchZoom: return "Toggle PinchZoom"
            case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
            case .toggleData: return "Toggle Data"
            case .toggleBarBorders: return "Toggle Bar Borders"
            // LineChart
            case .toggleGradientLine: return "Toggle Gradient Line"
            // CandleChart
            case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
            case .toggleShowCandleBar: return "Toggle show candle bar"
            // CombinedChart
            case .toggleLineValues: return "Toggle Line Values"
            case .toggleBarValues: return "Toggle Bar Values"
            case .removeDataSet: return "Remove Random Set"
            // CubicLineSampleFillFormatter
            case .toggleFilled: return "Toggle Filled"
            case .toggleCircles: return "Toggle Circles"
            case .toggleCubic: return "Toggle Cubic"
            case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
            case .toggleStepped: return "Toggle Stepped"
            // HalfPieChartController
            case .toggleXValues: return "Toggle X-Values"
            case .togglePercent: return "Toggle Percent"
            case .toggleHole: return "Toggle Hole"
            case .spin: return "Spin"
            case .drawCenter: return "Draw CenterText"
            case .toggleLabelsMinimumAngle: return "Toggle Labels Minimum Angle"
            // RadarChart
            case .toggleXLabels: return "Toggle X-Labels"
            case .toggleYLabels: return "Toggle Y-Labels"
            case .toggleRotate: return "Toggle Rotate"
            case .toggleHighlightCircle: return "Toggle highlight circle"
            }
        }
    }
}
