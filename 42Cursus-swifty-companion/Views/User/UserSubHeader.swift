//
//  UserSubHeader.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

struct UserSubHeader: View {
    var user: User42?
    @Binding var activeCursus: CursusUser42?
    @State private var showingCursus = false
    
    var body: some View {
        VStack {
            Button(action: {
                showingCursus = true
            }) {
                Label(activeCursus?.grade ?? activeCursus?.cursus.name ?? "Select a cursus", systemImage: "arrow.up.arrow.down.circle")
            }
            .confirmationDialog("Select a cursus", isPresented: $showingCursus, titleVisibility: .visible) {
                if let cursusUsers = user?.cursusUsers {
                    ForEach(cursusUsers, id: \.cursusId) { cursus in
                        Button(cursus.grade ?? cursus.cursus.name) {
                            activeCursus = cursus
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
