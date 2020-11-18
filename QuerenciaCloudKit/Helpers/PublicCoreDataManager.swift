//
//  PublicCoreDataManager.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/12/20.
//

import Foundation
import CoreData
import CloudKit

class PublicCoreDataManager {
    
    var currentResources = [CurrentResources]()
    var allResources = [AllResources]()
    var quotes = [MotivationalQuotes]()
    var allPrompts = [String]()
    
    func saveCurrent(_ title: String, _ subtitle: String, _ actionUrl: String, _ imageUrl: String, _ category: String, _ categoryAndNumber: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CurrentResources", in: AppDelegate.publicViewContext)!
        
        let resourceEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.publicViewContext)
        
        load("CurrentResources") { [self] (returnedArray: [NSManagedObject]) in
            currentResources = returnedArray as! [CurrentResources]
            for resource in 0...currentResources.count - 1 {
                if currentResources[resource].categoryAndNumber == categoryAndNumber {
                    AppDelegate.publicViewContext.delete(currentResources[resource])
                }
            }
        }
        
        resourceEntity.setValue(title, forKey: "title")
        resourceEntity.setValue(subtitle, forKey: "subtitle")
        resourceEntity.setValue(actionUrl, forKey: "actionUrl")
        resourceEntity.setValue(imageUrl, forKey: "imageUrl")
        resourceEntity.setValue(category, forKey: "category")
        resourceEntity.setValue(categoryAndNumber, forKey: "categoryAndNumber")
        
        do {
            try AppDelegate.publicViewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveAll(_ title: String, _ subtitle: String, _ actionUrl: String, _ imageUrl: String, _ category: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AllResources", in: AppDelegate.publicViewContext)!
        
        let resourceEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.publicViewContext)
        
        load("AllResources") { [self] (returnedArray: [NSManagedObject]) in
            allResources = returnedArray as! [AllResources]
            for resource in 0...allResources.count - 1 {
                if allResources[resource].actionUrl == actionUrl {
                    AppDelegate.publicViewContext.delete(allResources[resource])
                }
            }
        }
        
        resourceEntity.setValue(title, forKey: "title")
        resourceEntity.setValue(subtitle, forKey: "subtitle")
        resourceEntity.setValue(actionUrl, forKey: "actionUrl")
        resourceEntity.setValue(imageUrl, forKey: "imageUrl")
        resourceEntity.setValue(category, forKey: "category")
        
        do {
            try AppDelegate.publicViewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveQuote(_ title: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "MotivationalQuotes", in: AppDelegate.publicViewContext)!
        
        let resourceEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.publicViewContext)
        
        load("MotivationalQuotes") { [self] (returnedArray: [NSManagedObject]) in
            quotes = returnedArray as! [MotivationalQuotes]
            for quote in 0...quotes.count - 1 {
                if quotes[quote].quote == title {
                    AppDelegate.publicViewContext.delete(quotes[quote])
                }
            }
        }
        
        resourceEntity.setValue(title, forKey: "quote")
        
        do {
            try AppDelegate.publicViewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func savePrompt(_ prompt: String) {
        let entity = NSEntityDescription.entity(forEntityName: "AllPrompts", in: AppDelegate.publicViewContext)!
        
        let resourceEntity = NSManagedObject(entity: entity, insertInto: AppDelegate.publicViewContext)
        
        load("AllPrompts") { [self] (returnedArray: [NSManagedObject]) in
            let prompts = returnedArray[0] as? AllPrompts
            allPrompts = prompts?.allPrompts ?? []
            if allPrompts.contains(where: {$0 == prompt}) {
                return
            } else {
                allPrompts.append(prompt)
            }
        }
        resourceEntity.setValue(allPrompts, forKey: "allPrompts")
        
        do {
            try AppDelegate.publicViewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        
        let context = AppDelegate.publicViewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentResources")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch
        {
            print ("There was an error")
        }
    }
    
    func load(_ name: String,completion: @escaping ([NSManagedObject]) -> ()) {
        
        let managedContext = AppDelegate.publicViewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            completion(fetch)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
