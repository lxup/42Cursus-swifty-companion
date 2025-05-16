//
//  Achievement42.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import Foundation

struct Achievement42: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String?
    var tier: String?
    var kind: String?
    var visible: Bool?
    var image: String?
    var nbrOfSuccess: Int?
    var usersUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, tier, kind, visible, image
        case nbrOfSuccess = "nbr_of_success"
        case usersUrl = "users_url"
    }
    
    var imageUrl: String? {
        guard let image = image else { return nil }
        let cleanPath = image.replacingOccurrences(of: "/uploads/", with: "/")
        return "https://cdn.intra.42.fr\(cleanPath)"
    }
}
