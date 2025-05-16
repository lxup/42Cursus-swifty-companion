//
//  UserAchievementsView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

struct UserAchievementsView: View {
    var user: User42?
    @Binding var activeCursus: CursusUser42?
    
    var body: some View {
        let uniqueAchievements = (user?.achievements ?? [])
            .reduce(into: [String: Achievement42]()) { acc, current in
                let key = current.name
                if let existing = acc[key] {
                    let currentSuccess = current.nbrOfSuccess ?? 0
                    let existingSuccess = existing.nbrOfSuccess ?? 0
                    if currentSuccess > existingSuccess {
                        acc[key] = current
                    }
                } else {
                    acc[key] = current
                }
            }
            .map { $0.value }
        if uniqueAchievements.isEmpty == false {
            List(uniqueAchievements) { achievementUser in
                HStack {
                    AsyncSVGImage(url: URL(string: achievementUser.imageUrl ?? "")) { image in
                        image.resizable()
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                    }
                    VStack(alignment: .leading) {
                        Text(achievementUser.name)
                            .lineLimit(2)
                        if let description = achievementUser
                            .description {
                            Text(description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
        } else {
            Text("No achievements found")
                .foregroundStyle(.secondary)
        }
    }
}
