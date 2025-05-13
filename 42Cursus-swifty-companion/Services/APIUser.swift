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
    
    @MainActor
    func fetch(
        token: String,
        login: String
    ) async {
        isLoading = true
        defer {
            isLoading = false
            isInitialized = true
        }
        do {
            let urlComponents = URLComponents(string: "\(APIConstants.shared.apiURL)/users/\(login.lowercased())")!
            
            guard let requestURL = urlComponents.url else {
                value = nil
                return
            }

            var request = URLRequest(url: requestURL)
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            value = try decoder.decode(User42.self, from: data)
        } catch {
            print("Error: Failed to fetch user -> \(login)")
        }
    }
}
