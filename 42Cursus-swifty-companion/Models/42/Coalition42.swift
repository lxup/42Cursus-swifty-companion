//
//  Coalition42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import Foundation

struct Coalition42: Codable, Identifiable {
    var id: Int
    var name: String
    var slug: String
    var imageUrl: String?
    var color: String?
    var score: Int
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case imageUrl = "image_url"
        case color
        case score
        case userId = "user_id"
    }
}
