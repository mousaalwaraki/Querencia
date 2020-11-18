//
//  APIManager.swift
//  HintPod
//
//  Created by Marawan Alwaraki on 23/03/2019.
//

import Foundation

class APIManager {
    
    static func loadSuggestions(success: @escaping ([Suggestion]) -> (), error: @escaping (String) -> ()) {
        
        guard let projectId: String = UserDefaults.standard.string(forKey: "HPProjectId") else {
            error("Failed to load project id")
            return;
        }
        
        guard let companyId: String = UserDefaults.standard.string(forKey: "HPCompanyId") else {
                error("Failed to load company id")
                return;
        }
        
        let url = URL(string: Constants.baseURL + "loadSuggestions?projectId=\(projectId)" +
        "&companyId=\(companyId)")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard let data = data, errorMessage == nil else {
                error("Failed to load suggestions")
                 return
             }
            
            let suggestions = try! JSONDecoder().decode([Suggestion].self, from: data)
            success(suggestions)
            
        }.resume()
    }
    
    static func addSuggestion(title: String, content: String, success: @escaping () -> (), error: @escaping (String) -> ()) {
        
        guard let userId: String = UserDefaults.standard.string(forKey: "HPUserId") else {
            error("Failed to load user id")
            return;
        }
        guard let projectId: String = UserDefaults.standard.string(forKey: "HPProjectId") else {
            error("Failed to load project id")
            return;
        }
        
        var parameters = "addSuggestion?title=\(title)&content=\(content)&userId=\(userId)&projectId=\(projectId)"
        
        parameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: Constants.baseURL + parameters)!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard errorMessage == nil else {
                 // Handle Empty Data
                error("Failed to add suggestion, \(errorMessage?.localizedDescription ?? "unkown error")")
                 return
             }
            success()
            
        }.resume()
    }
    
    static func loadComments(suggestionId: String, success: @escaping ([Comment]) -> (), error: @escaping (String) -> ()) {
        
        let url = URL(string: Constants.baseURL + "loadComments?suggestionId=\(suggestionId)")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard let data = data, errorMessage == nil else {
                error("Failed to load suggestions")
                 return
             }
            
            let comments = try! JSONDecoder().decode([Comment].self, from: data)
            success(comments)
            
        }.resume()
    }
    
    static func addComment(suggestionId: String, comment: String, success: @escaping () -> (), error: @escaping (String) -> ()) {
        
        guard let userId: String = UserDefaults.standard.string(forKey: "HPUserId") else {
            error("Failed to load user id")
            return;
        }
        
        var parameters = "addComment?userId=\(userId)&content=\(comment)&suggestionId=\(suggestionId)"
        parameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: Constants.baseURL + parameters)!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard errorMessage == nil else {
                 // Handle Empty Data
                error("Failed to add comment, \(errorMessage?.localizedDescription ?? "unkown error")")
                 return
             }
            success()
            
        }.resume()
    }
    
    static func vote(suggestionId: String, upvote: Bool, voting: Bool, success: @escaping () -> (), error: @escaping (String) -> ()) {
        
        guard let userId: String = UserDefaults.standard.string(forKey: "HPUserId") else {
            error("Failed to load user id")
            return;
        }
        guard let projectId: String = UserDefaults.standard.string(forKey: "HPProjectId") else {
            error("Failed to load project id")
            return;
        }
        
        var parameters = "voteSuggestion?userId=\(userId)&projectId=\(projectId)"
            + "&suggestionId=\(suggestionId)&upvote=\(upvote ? "true" : "false")"
            + "&voting=\(voting ? "true" : "false")"
        
        parameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: Constants.baseURL + parameters)!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard errorMessage == nil else {
                 // Handle Empty Data
                error("Failed to vote on suggestion, \(errorMessage?.localizedDescription ?? "unkown error")")
                 return
             }
            success()
            
        }.resume()
        
    }
    
    static func registerUser(id: String, name: String?, success: @escaping (String) -> (), error: @escaping (String) -> ()) {
        
        guard let projectId: String = UserDefaults.standard.string(forKey: "HPProjectId") else {
            error("Failed to load project id")
            return;
        }
        
        var parameters = ""
        if name == nil {
            parameters = "verifyUser?uniqueId=\(id)&projectId=\(projectId)"
        } else {
            parameters = "verifyUser?uniqueId=\(id)&name=\(name!)&projectId=\(projectId)"
        }
        
        parameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        parameters = parameters.replacingOccurrences(of: " ", with: "+")
        
        let url = URL(string: Constants.baseURL + parameters)!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, errorMessage: Error?) in
            
             guard let data = data, errorMessage == nil else {
                 // Handle Empty Data
                error("Failed to verify user, \(errorMessage?.localizedDescription ?? "unkown error")")
                 return
             }
            
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            success(responseString!)
            
        }.resume()
    }
    
}
