//
//  HomeView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 09/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var token: APIToken = APIToken()
    @State private var showErrorAlert = false
    
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
                    
                    if let error = token.error {
                        VStack(spacing: 8) {
                            Button {
                                showErrorAlert = true
                            } label: {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 40))
                            }
                            Text("Failed to fetch token")
                            Button("Retry") {
                                Task {
                                    await token.getToken()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .alert("Error", isPresented: $showErrorAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text(error.localizedDescription)
                        }
                    } else if token.value != nil {
                        SearchView()
                            .padding()
                            .environmentObject(token)
                    } else if token.isLoading {
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
