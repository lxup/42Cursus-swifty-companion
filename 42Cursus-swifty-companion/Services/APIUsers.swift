//
//  APIUsers.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

class APIUsers: ObservableObject {
    @Published var campusId: Int
    @Published var results: [User42]?
    @Published var isLoading: Bool = false
    
    init(campusId: Int = 1) {
        self.campusId = campusId
    }
    
    @MainActor
    func fetch(token: String, searchTerm: String? = nil) async {
        isLoading = true
        do {
            let endpoint = URL(string: "\(APIConstants.shared.apiURL)/campus/\(campusId)/users")!
            
            guard let requestURL = URL(string: "\(endpoint)") else {
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
            print(error)
            print("Error: Failed to fetch users.")
        }
        isLoading = false
    }
}
