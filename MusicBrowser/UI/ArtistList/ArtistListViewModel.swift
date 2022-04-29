//
//  ArtistListViewModel.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import CombineRex
import SwiftRex

enum ArtistListViewModel {
    
    static func viewModel<S: StoreType>(from store: S) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: ViewState.fromAppState(_:))
            .asObservableViewModel(initialState: .initialState)
    }
    
    struct ViewState: Equatable {
        var artists: [String]
        var filteredArtists: [String]
        var query: String
        var isLoading: Bool
        let title = "Artists"
        
        static var initialState:  ViewState {
            ViewState(artists: [],
                      filteredArtists: [],
                      query: "",
                      isLoading: false)
        }
        
        static func fromAppState(_ state: AppState) -> ViewState {
            var artists: [String]
            var isLoading: Bool
            switch state.albums {
            case .loading:
                artists = []
                isLoading = true
            case .neverLoaded:
                artists = []
                isLoading = false
            case .loaded(let loadedAlbums):
                artists = loadedAlbums.map { $0.artist }
                isLoading = false
            }
            
            artists = artists.sorted { $0 < $1 }.unique()
            
            let query = state.query
            
            let filteredArtists = query.isEmpty ? artists : artists.filter { artist in
                artist.contains(query)
            }
            
            return ViewState(artists: artists,
                             filteredArtists: filteredArtists,
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
