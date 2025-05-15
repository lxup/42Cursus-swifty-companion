//
//  AvatarComponent.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

struct AvatarComponent: View {
    var imageURL: String?
    var fallbackText: String
    var size: CGFloat = 50
    @Environment(\.redactionReasons) private var redactionReasons
    
    var body: some View {
        ZStack {
                if redactionReasons.contains(.placeholder) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: .infinity, height: .infinity)
                } else if let imageURL = imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                } else {
                    Text(String(fallbackText.prefix(1)).uppercased())
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.white)
                        .frame(width: size, height: size)
                        .background(Color.accentColor)
                }
            }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

