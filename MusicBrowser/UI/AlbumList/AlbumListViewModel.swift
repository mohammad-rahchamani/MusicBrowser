//
//  AlbumListViewModel.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import CombineRex
import SwiftRex

enum AlbumListViewModel {
    
    static func viewModel<S: StoreType>(from store: S, withTitle title: String) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: { ViewState.fromAppState($0, title: title) })
            .asObservableViewModel(initialState: ViewState.initialState(for: title))
    }
    
    struct ViewState: Equatable {
        var albums: [MusicAlbum]
        var filteredAlbums: [MusicAlbum]
        var query: String
        var isLoading: Bool
        var title: String
        
        static func initialState(for title: String) ->  ViewState {
            ViewState(albums: [],
                      filteredAlbums: [],
                      query: "",
                      isLoading: false,
                      title: title)
        }
        
        static func fromAppState(_ state: AppState, title: String) -> ViewState {
            var albums: [MusicAlbum]
            var isLoading: Bool
            switch state.albums {
            case .loading:
                albums = []
                isLoading = true
            case .neverLoaded:
                albums = []
                isLoading = false
            case .loaded(let loadedAlbums):
                albums = loadedAlbums
                isLoading = false
            }
            
            albums.sort { $0.album < $1.album }
            
            let query = state.query
            
            let filteredAlbums = query.isEmpty ? albums : albums.filter { album in
                album.album.contains(query) ||
                album.artist.contains(query) ||
                album.tracks.map { $0.contains(query) }.reduce(false, { $0 || $1 })
            }
            
            return ViewState(albums: albums,
                             filteredAlbums: filteredAlbums,
                             query: query,
                             isLoading: isLoading,
                             title: title)
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
