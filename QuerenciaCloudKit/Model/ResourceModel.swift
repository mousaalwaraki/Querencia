//
//  ResourceModel.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import Foundation

struct ResourceModel {
    var title : String?
    var subtitle : String?
    var actionUrl : String?
    var imageUrl : String?
    var category : Category?
}

enum Category : String, CaseIterable {
    case blog
    case video
    case book
}
