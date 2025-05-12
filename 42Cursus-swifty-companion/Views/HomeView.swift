//
//  HomeView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 09/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var token: APIToken = APIToken()
    
    // State
    
    
    var body: some View {
        NavigationStack{
            ZStack(alignment:.center) {
                VStack {
                    Image("42Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .foregroundColor(.accentColor)
                    Text("Ready to stalk ?")
                    
                    if (token.value != nil) {
                        SearchView()
                            .padding()
                    } else {
                        LoadingComponent()
                    }
                }
            }
        }
        .task {
            await token.getToken()
        }
    }
}

#Preview {
    HomeView()
}
