//
//  Store.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex
import CombineRex

class Store: ReduxStoreBase<AppAction, AppState> {
    
    static func createStore() -> Store {
        
        let appReducer = AlbumListReducer.lifted <> FilterReducer.lifted <> TabReducer.lifted
        
        let albumLoader = MusicLoader(session: .shared,
                                      url: URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json")!)
        
        let appMiddleware = AlbumLoaderMiddleware(albumLoader: albumLoader.load()).lifted()
        
        return Store(subject: .combine(initialValue: .initialState),
                     reducer: appReducer,
                     middleware: appMiddleware)
    }
    
}
