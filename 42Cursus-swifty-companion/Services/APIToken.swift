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
    @Published var isLoading: Bool = false

    func generateToken() async throws -> Token {
        let endpoint = URL(string: "\(APIConstants.shared.baseURL)/oauth/token")!
        let body = "grant_type=client_credentials&client_id=\(APIConstants.shared.uid)&client_secret=\(APIConstants.shared.secret)"

        var request = URLRequest(url: endpoint)
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
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            value = try await checkOrRefreshToken()
        } catch {
            print("Error: Failed to get or refresh token")
        }
    }
}
