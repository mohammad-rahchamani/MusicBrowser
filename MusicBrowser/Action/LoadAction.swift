//
//  LoadAction.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum LoadAction: Equatable {
    case startLoading
    case loadEnded([MusicAlbum])
    case loadFailed
    
    static func from(appAction: AppAction) -> LoadAction? {
        switch appAction {
        case .load(let action):
            return action
        }
    }
    
}
