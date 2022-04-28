//
//  FilterState.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

struct FilterState: Equatable {
    var query: String
    
    static func from(appState: AppState) -> FilterState {
        FilterState(query: appState.query)
    }
}
