//
//  TrackListViewModel.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import CombineRex
import SwiftRex

enum TrackListViewModel {
    
    static func viewModel<S: StoreType>(from store: S) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: ViewState.fromAppState(_:))
            .asObservableViewModel(initialState: .initialState)
    }
    
    struct ViewState: Equatable {
        var tracks: [String]
        var filteredTracks: [String]
        var query: String
        var isLoading: Bool
        let title = "Tracks"
        
        static var initialState:  ViewState {
            ViewState(tracks: [],
                      filteredTracks: [],
                      query: "",
                      isLoading: false)
        }
        
        static func fromAppState(_ state: AppState) -> ViewState {
            var tracks: [String]
            var isLoading: Bool
            switch state.albums {
            case .loading:
                tracks = []
                isLoading = true
            case .neverLoaded:
                tracks = []
                isLoading = false
            case .loaded(let loadedAlbums):
                tracks = loadedAlbums.flatMap { $0.tracks }
                isLoading = false
            }
            
            tracks = tracks.sorted { $0 < $1 }.unique()
            
            let query = state.query
            
            let filteredTracks = query.isEmpty ? tracks : tracks.filter { track in
                track.contains(query)
            }
            
            return ViewState(tracks: tracks,
                             filteredTracks: filteredTracks,
                             query: query,
                             isLoading: isLoading)
        }
    }
    
    enum ViewAction: Equatable {
        case filter(String)
        
        static func toAppAction(_ action: ViewAction) -> AppAction {
            switch action {
            case .filter(let string):
                return .filter(.filter(string))
            }
        }
        
    }
    
}
