//
//  HomeView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 09/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var token: APIToken = APIToken()
    
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
                        .font(.title)
                    
                    if (token.value != nil) {
                        SearchView()
                            .padding()
                            .environmentObject(token)
                    } else if (token.isLoading) {
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
