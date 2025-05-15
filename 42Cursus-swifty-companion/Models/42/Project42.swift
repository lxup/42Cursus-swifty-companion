//
//  Project42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import Foundation

struct Project42: Codable, Identifiable {
    var id: Int
    var name: String
    var slug: String
    var parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case parentId = "parent_id"
    }
}
