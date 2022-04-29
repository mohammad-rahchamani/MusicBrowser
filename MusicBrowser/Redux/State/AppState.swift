//
//  AppState.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum Loadable<T> {
    case neverLoaded
    case loading
    case loaded(T)
}

extension Loadable: Equatable where T: Equatable { }

struct AppState: Equatable {
    var albums: Loadable<[MusicAlbum]>
    
    var query: String
    
    var selectedTab: TabState
    
    static var initialState: AppState {
        AppState(albums: .neverLoaded, query: "", selectedTab: .album)
    }
}
