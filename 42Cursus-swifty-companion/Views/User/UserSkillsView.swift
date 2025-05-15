//
//  UserSkillsView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

struct UserSkillsView: View {
    var user: User42?
    @Binding var activeCursus: CursusUser42?
    
    var body: some View {
        if activeCursus?.skills.isEmpty == false {
            List(activeCursus?.skills ?? []) { skill in
                VStack {
                    Text(skill.name)
                    HStack(alignment: .center) {
                        Text("\(Int(skill.level))")
                            .font(.title)
                            .fontWeight(.bold)
                        UserLevelBarView(level: skill.level)
                    }
                }
            }
        } else {
            Text("No skills found")
                .foregroundStyle(.secondary)
        }
    }
}
