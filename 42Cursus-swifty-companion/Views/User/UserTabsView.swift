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
    
    var id: Self { self }
    
    var icon: String {
        switch self {
            case .projects: return "hammer"
            case .achievements: return "trophy"
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
                    if let catUIImage = ImageRenderer(content: buildTabView(tab: tab)).uiImage {
                        Image(uiImage: catUIImage)
                           .tag(tab)
                    }
                }
            }
                .pickerStyle(.segmented)
            TabView(selection: $activeTab) {
                UserProjectsView()
                    .tag(UserTabs.projects)
                UserAchievementsView()
                    .tag(UserTabs.achievements)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private func buildTabView(tab: UserTabs) -> some View {
        HStack {
            Image(systemName: tab.icon)
            Text(tab.rawValue)
        }
    }
}
