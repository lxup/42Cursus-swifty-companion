//
//  User.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

struct User42: Codable, Identifiable {
    var id: Int
    var email: String
    var login: String
    var firstName: String
    var lastName: String?
    var usualFullName: String?
    var usualFirstName: String?
    var url: String
    var phone: String?
    var displayname: String?
    var kind: String?
    var image: Image42?
    var staff: Bool?
    var correctionPoint: Int?
    var poolMonth: String?
    var poolYear: String?
    var location: String?
    var wallet: Int?
    var anonymizeDate: String?
    var dataErasureDate: String?
    var createdAt: String?
    var updatedAt: String?
    var alumnizedAt: String?
    var alumni: Bool?
    var active: Bool?
    var cursusUsers: [CursusUser42]?
    var projectsUsers: [ProjectUser42]?
    var achievements: [Achievement42]?
    var coalitions: [Coalition42]?
    var coalition: Coalition42?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case login
        case firstName = "first_name"
        case lastName = "last_name"
        case usualFullName = "usual_full_name"
        case usualFirstName = "usual_first_name"
        case url
        case phone
        case displayname
        case kind
        case image
        case staff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location
        case wallet
        case anonymizeDate = "anonymize_date"
        case dataErasureDate = "data_erasure_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alumnizedAt = "alumnized_at"
        case alumni = "alumni?"
        case active = "active?"
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
        case achievements
        case coalitions = "coalitions"
        case coalition
    }
}
