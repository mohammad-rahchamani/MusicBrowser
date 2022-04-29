//
//  TabState.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum TabState: Equatable {
    case artist
    case album
    case track
    
    static func from(appState: AppState) -> TabState {
        appState.selectedTab
    }
    
}
