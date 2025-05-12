//
//  TokenAPI.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import Foundation

struct APIConfig {
    static let shared = APIConfig()

    let uid: String
    let secret: String

    private init() {
        guard let url = Bundle.main.url(forResource: "env", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let uid = dict["API_UID"] as? String,
              let secret = dict["API_SECRET"] as? String else {
            fatalError("Error: Invalid or missing env.plist keys.")
        }

        self.uid = uid
        self.secret = secret
    }
}
