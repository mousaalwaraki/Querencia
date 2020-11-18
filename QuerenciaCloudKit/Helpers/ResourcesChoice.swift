//
//  ResourcesChoice.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import Foundation

enum ResourcesChoice {
    case blog
    case video
}

var resourceChoice : ResourcesChoice?

extension ResourcesChoice {
    func getTitle() -> String {
        switch self {
        case .blog:
            return "All Blogposts"
        case .video:
            return "All Videos"
        }
    }
    
    func getCase() -> String {
        switch self {
        case .blog:
            return "blog"
        case .video:
            return "video"
        }
    }
}
