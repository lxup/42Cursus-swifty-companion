//
//  SearchSheetView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

struct SearchSheetView: View {
    @StateObject private var users = APIUsers()
    @StateObject private var debouncedSearch = DebouncedState(initialValue: "", delay: 0.5)
    @EnvironmentObject var token: APIToken
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLogin: String?
    
    var body: some View {
        NavigationStack {
            if users.error != nil {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 40))
                    Text("Failed to fetch users.")
                    Button("Retry") {
                        Task {
                            if let accessToken = token.value?.accessToken {
                                await users.fetch(
                                    token: accessToken,
                                    searchTerm: debouncedSearch.debouncedValue,
                                    campusId: 1
                                )
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .cornerRadius(20)
            } else if users.results?.isEmpty == false {
                List {
                    ForEach(users.results ?? []) { user in
                        HStack {
                            AvatarComponent(imageURL: user.image.link, fallbackText: user.login)
                            Text(user.login)
                            Spacer()
                        }
                        .onTapGesture {
                            selectedLogin = user.login
                            dismiss()
                        }
                    }
                }
            } else if users.isLoading {
                LoadingComponent()
            } else {
                Text("No results found")
                    .foregroundStyle(.secondary)
            }
            
        }
        .searchable(
            text: $debouncedSearch.value,
            prompt: "Who do u wanna search?"
            
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .onAppear() {
            // Initial load
            Task {
                if let accessToken = token.value?.accessToken {
                    await users.fetch(
                        token: accessToken,
                        searchTerm: debouncedSearch.debouncedValue,
                        campusId: 1
                    )
                }
            }
        }
        .onChange(of: debouncedSearch.debouncedValue) { oldValue, newValue in
            Task {
                if let accessToken = token.value?.accessToken {
                    await users.fetch(
                        token: accessToken,
                        searchTerm: newValue,
                        campusId: 1
                    )
                }
            }
        }
    }
}
