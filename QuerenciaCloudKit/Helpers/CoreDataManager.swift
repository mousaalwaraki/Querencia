//
//  CoreDataManager.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var entries = [UserResponses]()
    var combinedCurrentDate: String?
    
    func save(_ date: String,_ dayFeeling: Int16,_ dayQuestions: [String],_ dayResponses: [String],_ dayTags: [String],_ journalName: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "UserResponses", in: AppDelegate.viewContext)!
        
        let journalEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.viewContext)
        
        load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            entries = returnedArray as! [UserResponses]
            getTodaysDate()
            for entry in 0...entries.count - 1 {
                if entries[entry].date == combinedCurrentDate {
                    AppDelegate.viewContext.delete(entries[entry])
                }
            }
        }
        
        journalEntity.setValue(date, forKey: "date")
        journalEntity.setValue(dayFeeling, forKey: "dayFeeling")
        journalEntity.setValue(dayQuestions, forKey: "dayQuestions")
        journalEntity.setValue(dayResponses, forKey: "dayResponses")
        journalEntity.setValue(dayTags, forKey: "dayTags")
        journalEntity.setValue(journalName, forKey: "journalName")
        
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveUserTags(_ tags: [String]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "UserTags", in: AppDelegate.viewContext)!
        
        let tagsEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.viewContext)
        
        deleteActivities()
        tagsEntity.setValue(tags, forKey: "allTags")
        
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveUserJournals(_ userTitle: String,_ title: String,_ questions: [String]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "UserJournals", in: AppDelegate.viewContext)!
        
        let journalEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.viewContext)
        
        journalEntity.setValue(userTitle, forKey: "userTitle")
        journalEntity.setValue(title, forKey: "title")
        journalEntity.setValue(questions, forKey: "questions")
        
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteUserJournal(_ title: String) {
        load("UserJournals") { (returnedArray: [NSManagedObject]) in
            let journals = returnedArray as! [UserJournals]
            for journal in journals {
                if journal.title == title {
                    AppDelegate.viewContext.delete(journal)
                }
            }
        }
    }
    
    func updateUserJournalName(_ title: String,_ newName: String) {
        load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            let journals = returnedArray as! [UserJournals]
            for journal in 0...journals.count - 1 {
                if journals[journal].title == title {
                    deleteUserJournal(title)
                    saveUserJournals(newName, title, journals[journal].questions ?? [])
                }
            }
        }
    }
    
    func updateUserJournalQuestions(_ title: String,_ questions: [String]) {
        load("UserJournals") { [self] (returnedArray: [NSManagedObject]) in
            let journals = returnedArray as! [UserJournals]
            for journal in 0...journals.count - 1 {
                if journals[journal].title == title {
                    deleteUserJournal(title)
                    saveUserJournals(journals[journal].userTitle!, title, questions)
                }
            }
        }
    }
    
    func deleteAll() {
        
        let context = AppDelegate.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserResponses")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch
        {
            print ("There was an error")
        }
    }
    
    func deleteActivities() {
        let context = AppDelegate.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTags")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch
        {
            print ("There was an error")
        }    }
    
    func load(_ name: String,completion: @escaping ([NSManagedObject]) -> ()) {
        
        let managedContext = AppDelegate.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            completion(fetch)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
}
