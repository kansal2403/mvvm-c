//
//  Post.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 27/04/24.
//

import Foundation
struct Post: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
