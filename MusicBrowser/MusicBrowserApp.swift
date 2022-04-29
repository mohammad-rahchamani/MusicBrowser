//
//  MusicBrowserApp.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/28/22.
//

import SwiftUI

@main
struct MusicBrowserApp: App {
    
    let store = Store.createStore()
    
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: DashboardViewModel.viewModel(from: store),
                          albumPage: {
                AlbumListView(viewModel: AlbumListViewModel.viewModel(from: store))
            },
                        artistPage: {
                    Text("artists")
                },
                        trackPage: {
                ZStack {
                    Color.green
                    Text("ok")
                }
                .edgesIgnoringSafeArea(.all)
            })
        }
    }
}
