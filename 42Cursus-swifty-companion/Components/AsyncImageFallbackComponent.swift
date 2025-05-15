//
//  AsyncImageFallback.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

struct AsyncImageFallbackComponent: View {
    var imageURL: String?
    var size: CGFloat = 50
    @Environment(\.redactionReasons) private var redactionReasons

    var body: some View {
        ZStack {
            if redactionReasons.contains(.placeholder) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            } else if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure(_):
                        Image(systemName: "photo").resizable().scaledToFit()
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
            } else {
                Image(systemName: "photo").resizable().scaledToFit()
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .cornerRadius(size / 5)
    }
}

