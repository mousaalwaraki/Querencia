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
    func loadPublic(_ name: String,completion: @escaping ([CKRecord]) -> ()) {
        let query = CKQuery(recordType: name, predicate: NSPredicate(value: true))
        
//        CKContainer.default().
        CKContainer.init(identifier: "iCloud.com.MousaAlwaraki.QuerenciaCloudKit").database(with: .public).perform(query, inZoneWith: nil) { (records, error) in
            
            if let records = records {
                completion(records.sorted(by: {$0.creationDate ?? Date() > $1.creationDate ?? Date() }))
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
