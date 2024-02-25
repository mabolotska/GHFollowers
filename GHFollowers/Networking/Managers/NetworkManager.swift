//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager() // singleton
    private let baseURL = "https://api.github.com/users/"
     let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    typealias completionHandler = (Result<[Follower], GFError>) -> Void
    
    func getFollowers(for username: String, page: Int, completed: @escaping completionHandler) {
        let endPoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            completed(Result.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(Result.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(Result.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // specifies the type of decoding
                let followers = try decoder.decode([Follower].self, from: data)
                completed(Result.success(followers))
            } catch {
                completed(Result.failure(.invalidData))
            }
            
        }
        task.resume()
    }
}
