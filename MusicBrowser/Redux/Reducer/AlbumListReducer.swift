//
//  AlbumListReducer.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex

struct AlbumListReducer {
    
    private static let reducer = Reducer<LoadAction, LoadState>.reduce { action, state in
        switch action {
        case .loadFailed:
            state.albums = .neverLoaded
        case .startLoading:
            state.albums = .loading
        case .loadEnded(let albums):
            state.albums = .loaded(albums)
        }
    }
//    let a = reducer.li
    static let lifted = reducer.lift(actionGetter: LoadAction.from(appAction:),
                                     stateGetter: LoadState.from(appState:),
                                     stateSetter: { $0.albums = $1.albums })
    
}
