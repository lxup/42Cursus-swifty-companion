//
//  UserTabs.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

enum UserTabs: String, CaseIterable, Identifiable {
    case projects = "Projects"
    case achievements = "Achievements"
    case skills = "Skills"
    
    var id: Self { self }
    
    var icon: String {
        switch self {
            case .projects: return "hammer"
            case .achievements: return "trophy"
            case .skills: return "bolt"
        }
    }
}

struct UserTabsView: View {
    var user: User42?
    @Binding var activeCursus: CursusUser42?
    @State private var activeTab: UserTabs = .projects
    var body: some View {
        VStack(spacing: 15) {
            Picker("", selection: $activeTab) {
                ForEach(UserTabs.allCases) { tab in
                    Image(systemName: tab.icon)
                }
            }
                .pickerStyle(.segmented)
            TabView(selection: $activeTab) {
                UserProjectsView(user: user, activeCursus: $activeCursus)
                    .tag(UserTabs.projects)
                UserAchievementsView(user: user, activeCursus: $activeCursus)
                    .tag(UserTabs.achievements)
                UserSkillsView(user: user, activeCursus: $activeCursus)
                    .tag(UserTabs.skills)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
