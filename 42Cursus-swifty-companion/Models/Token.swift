//
//  Token.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let createdAt: Date
    var expirationDate: Date {
        return createdAt.addingTimeInterval(TimeInterval(expiresIn))
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case createdAt = "created_at"
    }
}
