//
//  APIUsers.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

class APIUsers: ObservableObject {
    @Published var results: [User42]?
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetch(
        token: String,
        searchTerm: String? = nil,
        campusId: Int? = nil
    ) async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            var urlComponents = URLComponents(string: "\(APIConstants.shared.apiURL)/users")!
            // Build filters
            var queryItems: [URLQueryItem] = []
            if let campusId = campusId {
                queryItems.append(URLQueryItem(name: "campus_id", value: String(campusId)))
            }
            
            if let search = searchTerm?
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines),
               !search.isEmpty {
                    queryItems.append(URLQueryItem(name: "range[login]", value: "\(search),\(search)z"))
                }
            urlComponents.queryItems = queryItems
            
            
            guard let requestURL = urlComponents.url else {
                results = nil
                return
            }

            var request = URLRequest(url: requestURL)
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            results = try decoder.decode([User42].self, from: data)
        } catch {
            print("Error: Failed to fetch users.")
        }
    }
}
