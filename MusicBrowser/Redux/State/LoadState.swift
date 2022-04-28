//
//  LoadState.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

struct LoadState: Equatable {
    var albums: Loadable<[MusicAlbum]>
    
    static func from(appState: AppState) -> LoadState {
        LoadState(albums: appState.albums)
    }
    
}
