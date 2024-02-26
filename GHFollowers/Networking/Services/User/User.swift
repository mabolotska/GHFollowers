//
//  User.swift
//  GHFollowers
//
//  Created by Maryna Bolotska on 24/02/24.
//

import Foundation
struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
    
}
