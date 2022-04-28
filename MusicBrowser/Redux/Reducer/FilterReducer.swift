//
//  FilterReducer.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex

struct FilterReducer {
    
    private static let reducer = Reducer<FilterAction, FilterState>.reduce { action, state in
        switch action {
        case .filter(let query):
            state.query = query
        }
    }
    
    static let lifted = reducer.lift(actionGetter: FilterAction.from(appAction:),
                                     stateGetter: FilterState.from(appState:),
                                     stateSetter: { $0.query = $1.query })
    
}
