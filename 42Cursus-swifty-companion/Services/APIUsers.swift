//
//  APIUsers.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import Foundation

class APIUsers: ObservableObject {
    @Published var results: [User42] = []
    @Published var error: Error? = nil
    @Published var isLoading: Bool = false
    @Published var isFinished: Bool = false
    
    private var currentPage: Int = 1
    private var currentSearchTerm: String?
    private var currentCampusId: Int?
    private var token: String?
    
    @MainActor
    func fetch(token: APIToken, searchTerm: String? = nil, campusId: Int? = nil) async {
        do {
            let validToken = try await token.checkOrRefreshToken()
            if self.token != validToken.accessToken {
                self.token = validToken.accessToken
            }
        } catch {
            self.error = error
            print("Error: Failed to fetch token")
            return
        }
        self.currentPage = 1
        self.currentSearchTerm = searchTerm
        self.currentCampusId = campusId
        self.isFinished = false
        self.results = []
        await fetchPage(page: currentPage)
    }
    
    @MainActor
    func fetchNextPage() {
        guard !isLoading, !isFinished, let _ = token else { return }
        currentPage += 1
        Task {
            await fetchPage(page: currentPage)
        }
    }
    
    @MainActor
    private func fetchPage(page: Int) async {
        self.error = nil
        isLoading = true
        defer { isLoading = false }

        do {
            var urlComponents = URLComponents(string: "\(APIConstants.shared.apiURL)/users")!
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
            if let campusId = currentCampusId {
                queryItems.append(URLQueryItem(name: "campus_id", value: "\(campusId)"))
            }
            if let search = currentSearchTerm?
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines),
                !search.isEmpty {
                let rangeValue = "\(search),\(search)z"
                queryItems.append(URLQueryItem(name: "range[login]", value: rangeValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
            }

            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else { return }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")

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
            let newUsers = try decoder.decode([User42].self, from: data)

            if newUsers.isEmpty {
                isFinished = true
            } else {
                results.append(contentsOf: newUsers)
            }
        } catch {
            print(error)
            self.error = error
            print("Error: Failed to fetch users")
        }
    }
}
