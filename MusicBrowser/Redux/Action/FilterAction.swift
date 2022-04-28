//
//  FilterAction.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum FilterAction: Equatable {
    case filter(String)
    
    static func from(appAction: AppAction) -> FilterAction? {
        switch appAction {
        case .filter(let action):
            return action
        default:
            return nil
        }
    }
    
    static func toAppAction(_ action: FilterAction) -> AppAction {
        .filter(action)
    }
    
}
