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
    @EnvironmentObject var token: APIToken
    
    var body: some View {
        VStack {
            if user.isInitialized && user.value == nil {
                Text("User not found")
            } else {
                HStack {
                    AvatarComponent(
                        imageURL: user.value?.image.link,
                        fallbackText: user.value?.login ?? "placeholder"
                    )
                    Text(user.value?.login ?? "placeholder")
                }
                .redacted(reason: !user.isInitialized ? .placeholder : [])
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                if let accessToken = token.value?.accessToken {
                    await user.fetch(
                        token: accessToken,
                        login: login
                    )
                }
            }
        }
    }
}
