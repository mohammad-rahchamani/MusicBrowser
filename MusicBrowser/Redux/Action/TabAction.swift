//
//  TabAction.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum TabAction: Equatable {
    case select(TabState)
    
    static func from(appAction: AppAction) -> TabAction? {
        switch appAction {
        case .tab(let action):
            return action
        default:
            return nil
        }
    }
    
    static func toAppAction(_ action: TabAction) -> AppAction {
        .tab(action)
    }
    
}
