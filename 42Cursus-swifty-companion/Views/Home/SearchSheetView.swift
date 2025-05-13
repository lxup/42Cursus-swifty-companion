//
//  SearchSheetView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

struct SearchSheetView: View {
    @StateObject private var users = APIUsers()
    @StateObject private var debouncedSearch = DebouncedState(initialValue: "")
    @EnvironmentObject var token: APIToken
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLogin: String?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users.results ?? []) { user in
                    HStack {
                        if (user.image.link != nil) {
                            AsyncImage(
                                url: URL(string: user.image.link!),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 50, maxHeight: 50)
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                        }
                        else {
                            Image("42Icon")
                                .resizable()
                                .frame(maxWidth: 50, maxHeight: 50)
                        }
                        Text(user.login)
                        Spacer()
                    }
                    .onTapGesture {
                        selectedLogin = user.login
                        dismiss()
                    }
                }
            }
            
        }
        .searchable(
            text: $debouncedSearch.value,
            prompt: "Who do you want to search?"
            
        )
        .disableAutocorrection(true)
        .onAppear() {
            // Initial load
            Task {
                if let accessToken = token.value?.accessToken {
                    await users.fetch(token: accessToken, searchTerm: debouncedSearch.debouncedValue)
                }
            }
        }
        .onChange(of: debouncedSearch.debouncedValue) { oldValue, newValue in
            Task {
                if let accessToken = token.value?.accessToken {
                    await users.fetch(token: accessToken, searchTerm: newValue)
                }
            }
        }
    }
}
