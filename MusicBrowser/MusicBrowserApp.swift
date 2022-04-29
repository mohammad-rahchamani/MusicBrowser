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
                AlbumListView(viewModel: AlbumListViewModel.viewModel(from: store)) { album in
                    HStack {
                        Text("\(album.album)")
                        Spacer()
                        Text("\(album.year)")
                    }
                }
            },
                        artistPage: {
                AlbumListView(viewModel: AlbumListViewModel.viewModel(from: store)) { album in
                    HStack {
                        Text("\(album.artist)")
                    }
                }
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
