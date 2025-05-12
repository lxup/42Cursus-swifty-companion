//
//  LoadingComponent.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import SwiftUI

struct LoadingComponent: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            .scaleEffect(1)
            .padding(.top, 5)
    }
}

#Preview {
    LoadingComponent()
}
