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
    @Published var error: Error? = nil

    func generateToken() async throws -> Token {
        let endpoint = URL(string: "\(APIConstants.shared.baseURL)/oauth/token")!
        let body = "grant_type=client_credentials&client_id=\(APIConstants.shared.uid)&client_secret=\(APIConstants.shared.secret)"

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: errorText]
            )
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return try decoder.decode(Token.self, from: data)
    }

    func checkOrRefreshToken() async throws -> Token {
        if let currentToken = value, Date() < currentToken.expirationDate.addingTimeInterval(-10) {
            return currentToken
        }

        return try await generateToken()
    }

    func getToken() async {
        self.error = nil
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            value = try await checkOrRefreshToken()
        } catch {
            self.error = error
            print("Error: Failed to get or refresh token")
        }
    }
}
