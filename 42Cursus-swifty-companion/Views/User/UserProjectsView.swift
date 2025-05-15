//
//  UserProjectsView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

struct UserProjectsView: View {
    var user: User42?
    @Binding var activeCursus: CursusUser42?
    
    var body: some View {
        var filteredProjects: [ProjectUser42] {
            let cursusId = activeCursus?.cursusId ?? -1
            return (user?.projectsUsers ?? [])
                .filter {
                    $0.cursusIds.contains(cursusId) && $0.status != "searching_a_group"
                }
                .sorted { lhs, rhs in
                    let isLhsInProgress = lhs.status == "in_progress" && lhs.validated != true
                    let isRhsInProgress = rhs.status == "in_progress" && rhs.validated != true

                    if isLhsInProgress, !isRhsInProgress {
                        return true
                    }
                    if !isLhsInProgress, isRhsInProgress {
                        return false
                    }

                    let formatter = ISO8601DateFormatter()
                    let lhsMarked = lhs.markedAt.flatMap { formatter.date(from: $0) }
                    let rhsMarked = rhs.markedAt.flatMap { formatter.date(from: $0) }

                    if let d0 = lhsMarked, let d1 = rhsMarked {
                        return d0 > d1
                    }

                    let lhsCreated = formatter.date(from: lhs.createdAt) ?? .distantPast
                    let rhsCreated = formatter.date(from: rhs.createdAt) ?? .distantPast
                    return lhsCreated > rhsCreated
                }
        }
        
        if filteredProjects.isEmpty == false {
            List(filteredProjects) { projectUser in
                HStack {
                    Text(projectUser.project.name)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if projectUser.validated == true {
                        Text("\(projectUser.finalMark ?? 0)")
                            .foregroundColor(.green)
                    } else if projectUser.status == "finished" {
                        Text("\(projectUser.finalMark ?? 0)")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "hourglass")
                            .foregroundColor(.orange)
                    }
                }
            }
        } else {
            Text("No projects found")
                .foregroundStyle(.secondary)
        }
    }
}
