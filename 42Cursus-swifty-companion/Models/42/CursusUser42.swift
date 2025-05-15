//
//  Cursus42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//


import Foundation

struct CursusUser42: Codable, Identifiable {
    var id: Int
    var beginAt: String
    var endAt: String?
    var grade: String?
    var level: Double
    var skills: [Skill42]
    var cursusId: Int
    var hasCoalition: Bool
    var blackholedAt: String?
    var createdAt: String
    var updatedAt: String
    var user: User42
    var cursus: Cursus42
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case grade
        case level
        case skills
        case cursusId = "cursus_id"
        case hasCoalition = "has_coalition"
        case blackholedAt = "blackholed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case cursus
    }
}
