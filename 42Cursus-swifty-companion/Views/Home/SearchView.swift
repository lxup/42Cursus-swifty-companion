//
//  SearchView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Button(action: {
            print("go search")
        }) {
            Label("Letsgo 🥷", systemImage: "magnifyingglass")
        }
        .buttonStyle(NavigationButtonStyle(backgroundColor: Color.red))
    }
}
