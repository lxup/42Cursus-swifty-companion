//
//  APIToken.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import Foundation

@MainActor
class APIToken: ObservableObject {
    @Published var value: Token? = nil

    func generateToken() async throws -> Token {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
        let body = "grant_type=client_credentials&client_id=\(APIConfig.shared.uid)&client_secret=\(APIConfig.shared.secret)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970 // format date

        let newToken = try decoder.decode(Token.self, from: data)
        return newToken
    }

    func checkOrRefreshToken() async throws -> Token {
        if let currentToken = value,
           Date() < currentToken.expirationDate.addingTimeInterval(-10) { // refrain token if the actual one expire in -10s
            return currentToken
        }

        return try await generateToken()
    }

    func getToken() async {
        do {
            value = try await checkOrRefreshToken()
        } catch {
            print("Error: Failed to get or refresh token")
        }
    }
}
