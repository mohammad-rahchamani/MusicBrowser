//
//  TabReducer.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex

struct TabReducer {
    
    private static let reducer = Reducer<TabAction, TabState>.reduce { action, state in
        switch action {
        case .select(let tabState):
            state = tabState
        }
    }
    
    static let lifted = reducer.lift(actionGetter: TabAction.from(appAction:),
                                     stateGetter: TabState.from(appState:),
                                     stateSetter: { $0.selectedTab = $1 })
    
}
