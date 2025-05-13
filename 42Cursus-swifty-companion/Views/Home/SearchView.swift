//
//  SearchView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var showSearchSheet: Bool = false
    @State private var selectedLogin: String?
    @EnvironmentObject var token: APIToken
    
    var body: some View {
        NavigationStack {
            Button(action: {
                showSearchSheet.toggle()
            }) {
                Label("Letsgo 🥷", systemImage: "magnifyingglass")
            }
            .buttonStyle(NavigationButtonStyle(backgroundColor: Color.red))
            .sheet(isPresented: $showSearchSheet) {
                SearchSheetView(selectedLogin: $selectedLogin)
            }
        }
        .navigationDestination(item: $selectedLogin) { login in
            UserView(login: login)
                .environmentObject(token)
        }
    }
}
