//
//  UserView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

struct UserView: View {
    var login: String
    @StateObject private var user = APIUser()
    @State private var activeCursus: CursusUser42?
    @EnvironmentObject var token: APIToken
    
    var body: some View {
        VStack {
            if user.error != nil {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 40))
                    Text("Failed to fetch user: \(login)")
                    Button("Retry") {
                        Task {
                            if let accessToken = token.value?.accessToken {
                                await user.fetch(
                                    token: accessToken,
                                    login: login
                                )
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .cornerRadius(20)
            } else if user.isInitialized && user.value == nil {
                Text("User not found")
            } else {
                HStack {
                    AvatarComponent(
                        imageURL: user.value?.image.link,
                        fallbackText: user.value?.login ?? "placeholder",
                        size: 100
                    )
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(user.value?.login ?? "placeholder")
                                .font(.largeTitle)
                            Spacer()
                            UserLocationView(location: user.value?.location)
                        }
                        HStack(alignment: .center) {
                            Text("\(Int(activeCursus?.level ?? 0))")
                                .font(.title)
                                .fontWeight(.bold)
                            UserLevelBarView(level: activeCursus?.level ?? 0)
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                if user.isInitialized && user.value != nil {
                    UserSubHeaderView(user: user.value, activeCursus: $activeCursus)
                    UserTabsView(user: user.value, activeCursus: $activeCursus)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .redacted(reason: !user.isInitialized ? .placeholder : [])
        .onAppear {
            Task {
                if let accessToken = token.value?.accessToken {
                    await user.fetch(
                        token: accessToken,
                        login: login
                    )
                }
            }
        }
        .onChange(of: user.value?.id) {
            if let cursus = user.value?.cursusUsers {
                activeCursus = cursus
                    .sorted {
                        (APIConstants.shared.preferredCursusOrder.firstIndex(of: $0.cursusId) ?? Int.max)
                        <
                        (APIConstants.shared.preferredCursusOrder.firstIndex(of: $1.cursusId) ?? Int.max)
                    }
                    .first
            }
        }
    }
}

#Preview {
    struct AsyncTestView: View {
        @StateObject var token: APIToken = APIToken()
        var body: some View {
            VStack {
                if (token.value != nil) {
                    UserView(login: "lquehec")
                        .environmentObject(token)
                } else if (token.isLoading) {
                    LoadingComponent()
                }
            }
            .task {
                await token.getToken()
            }
        }
    }
    
    return AsyncTestView()
}
