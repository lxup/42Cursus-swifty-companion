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

    private init() {
        guard let url = Bundle.main.url(forResource: "env", withExtension: "plist"),
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
    }
//    static let uid: String = loadPlistValue(forKey: "API_UID")
//    static let secret: String = loadPlistValue(forKey: "API_SECRET")
//    
//    static var baseURL: String {
//        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
//            fatalError("BASE_URL not found in Info.plist")
//        }
//        return url
//    }
//
//    private static func loadPlistValue(forKey key: String) -> String {
//        guard let url = Bundle.main.url(forResource: "env", withExtension: "plist"),
//              let data = try? Data(contentsOf: url),
//              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
//              let value = dict[key] as? String else {
//            fatalError("\(key) not found in env.plist")
//        }
//        return value
//    }
}
