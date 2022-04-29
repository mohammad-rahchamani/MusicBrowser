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
                ArtistListView(viewModel: ArtistListViewModel.viewModel(from: store)) { artist in
                    Text("\(artist)")
                }
                },
                        trackPage: {
                TrackListView(viewModel: TrackListViewModel.viewModel(from: store)) { track in
                        Text("\(track)")
                }
            })
        }
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
