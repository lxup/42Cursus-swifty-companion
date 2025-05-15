//
//  Cursus42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import Foundation

struct Cursus42: Codable, Identifiable {
    var id: Int
    var createdAt: String
    var name: String
    var slug: String
    var kind: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case slug
        case kind
    }
}
