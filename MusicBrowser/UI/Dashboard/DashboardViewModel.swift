//
//  DashboardViewModel.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex
import CombineRex

enum DashboardViewModel {
    
    static func viewModel<S: StoreType>(from store: S) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: ViewState.fromAppState(_:))
            .asObservableViewModel(initialState: .initialState)
    }
    
    struct ViewState: Equatable {
        var selectedTab: TabState
        
        static var initialState: ViewState {
            return ViewState(selectedTab: .album)
        }
        
        static func fromAppState(_ state: AppState) -> ViewState {
            ViewState(selectedTab: state.selectedTab)
        }
    }
    
    enum ViewAction: Equatable {
        case show
        case select(TabState)
        
        static func toAppAction(_ action: ViewAction) -> AppAction {
            switch action {
            case .show:
                return .load(.startLoading)
            case .select(let tab):
                return .tab(.select(tab))
            }
        }
        
    }
    
}
