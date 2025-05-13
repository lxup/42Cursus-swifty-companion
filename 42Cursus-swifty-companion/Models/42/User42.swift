//
//  User.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

struct User42: Codable, Identifiable {
    var id: Int
    var login: String
    var image: Image42
    var location: String?
}
