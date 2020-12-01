//
//  Resource.swift
//  QuerenciaCloudKit
//
//  Created by Marwan Elwaraki on 28/11/2020.
//

import Foundation
import CloudKit

class Resource {
    var title: String = ""
    var subtitle: String = ""
    var imageUrl: String = ""
    var actionUrl: String = ""
    var category: String = ""
    
    init(record: CKRecord) {
        title = record.value(forKey: "title") as? String ?? ""
        subtitle = record.value(forKey: "subtitle") as? String ?? ""
        imageUrl = record.value(forKey: "imageUrl") as? String ?? ""
        actionUrl = record.value(forKey: "actionUrl") as? String ?? ""
        category = record.value(forKey: "category") as? String ?? ""
    }
}
