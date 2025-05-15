//
//  ProjectUser42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import Foundation

struct ProjectUser42: Codable, Identifiable {
    var id: Int
    var occurrence: Int
    var finalMark: Int?
    var status: String
    var validated: Bool
    var currentTeamId: Int
    var project: Project42
    var cursusIds: [Int]
    var markedAt: String?
    var market: Bool
    var retriableAt: String?
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamId = "current_team_id"
        case project
        case cursusIds = "cursus_ids"
        case markedAt = "marked_at"
        case market
        case retriableAt = "retriable_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
