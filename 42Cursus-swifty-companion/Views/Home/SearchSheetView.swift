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
            
        }
        .searchable(
            text: $debouncedSearch.value,
            prompt: "Who do you want to search?"
            
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
