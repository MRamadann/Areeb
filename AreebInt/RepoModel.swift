//
//  RepoModel.swift
//  AreebInt
//
//  Created by Apple on 19/10/2023.
//

import Foundation
struct Repository: Codable{
    var name: String?
    var owner: Owner?
    var url: String?
    var created_at: String?
    var id: Int?
    var description: String?
}

struct Owner: Codable{
    var avatar_url: String?
    var login: String?
}
