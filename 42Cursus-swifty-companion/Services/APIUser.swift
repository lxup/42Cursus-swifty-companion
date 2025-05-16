//
//  APIUser.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

class APIUser: ObservableObject {
    @Published var value: User42?
    @Published var isInitialized: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    @MainActor
    func fetch(
        token: String,
        login: String
    ) async {
        self.error = nil
        isLoading = true
        defer {
            isLoading = false
            isInitialized = true
        }
        do {
            self.value = try await fetchUser(token: token, login: login)

//            self.value?.coalitions = try await fetchCoalitions(token: token, login: login)
//            self.value?.coalition = self.value?.coalitions?.last
        } catch {
            self.error = error
            print("Error: Failed to fetch user -> \(login)")
        }
    }
    
    // REQUESTS
    private func fetchUser(token: String, login: String) async throws -> User42 {
        let urlComponents = URLComponents(string: "\(APIConstants.shared.apiURL)/users/\(login.lowercased())")!
        guard let requestURL = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: requestURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: errorText]
            )
        }
        return try JSONDecoder().decode(User42.self, from: data)
    }
        
    private func fetchCoalitions(token: String, login: String) async throws -> [Coalition42] {
        let urlComponents = URLComponents(string: "\(APIConstants.shared.apiURL)/users/\(login.lowercased())/coalitions")!
        guard let requestURL = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: requestURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Coalition42].self, from: data)
    }
}
