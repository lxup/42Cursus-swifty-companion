//
//  APIConstants.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

struct APIConstants {
    static let shared = APIConstants()

    let baseURL: String
    let apiVersion: String
    let apiURL: String
    let uid: String
    let secret: String
    let preferredCursusOrder: [Int]

    private init() {
        guard let url = Bundle.main.url(forResource: "Env", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let baseURL = dict["API_BASE_URL"] as? String,
              let apiVersion = dict["API_VERSION"] as? String,
              let uid = dict["API_UID"] as? String,
              let secret = dict["API_SECRET"] as? String else {
            fatalError("Error: Invalid or missing env.plist keys.")
        }

        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.apiURL = "\(baseURL)/\(apiVersion)"
        self.uid = uid
        self.secret = secret
        self.preferredCursusOrder = [21, 9]
    }
}
