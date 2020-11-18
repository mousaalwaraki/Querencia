//
//  Comment.swift
//  HintPod
//
//  Created by Marawan Alwaraki on 06/04/2019.
//

import Foundation

class Comment: Codable {
    
    var id: String!
    var content: String?
    var uid: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case content, uid, name
    }
    
    init(json: AnyObject) {
        
        var dict:Dictionary<String, AnyObject>!
        
        dict = json as? Dictionary<String, AnyObject>
        
        self.id = dict["key"] as? String
        self.content = dict["content"] as? String ?? "Error comment"
        self.uid = dict["uid"] as? String
        self.name = dict["name"] as? String ?? "Error name"
    }
    
}
