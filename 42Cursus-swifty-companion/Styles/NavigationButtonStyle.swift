//
//  NavigationButtonStyle.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 12/05/2025.
//

import SwiftUI

struct NavigationButtonStyle: ButtonStyle {
    let color: Color
    let backgroundColor: Color
    let padding: CGFloat
    
    init(
        color: Color = .white,
        backgroundColor: Color = .blue,
        padding: CGFloat = 10
    ) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.padding = padding
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(backgroundColor)
            )
    }
}
