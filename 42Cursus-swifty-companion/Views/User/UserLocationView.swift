//
//  UserLocation.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 15/05/2025.
//

import SwiftUI

struct UserLocationView: View {
    var location: String?
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "location.circle")
                .foregroundColor(location != nil ? .green : .orange)
            Text(location ?? "Unavailable")
                .foregroundColor(location != nil ? .primary : .orange)
        }
    }
}
