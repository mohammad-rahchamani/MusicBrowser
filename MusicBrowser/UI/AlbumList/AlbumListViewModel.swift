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
    
    static func viewModel<S: StoreType>(from store: S,
                                        withTitle title: String,
                                        sorter: @escaping (MusicAlbum, MusicAlbum) -> Bool) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: { ViewState.fromAppState($0, title: title, sort: sorter) })
            .asObservableViewModel(initialState: ViewState.initialState(for: title, sorting: { _, _ in true }))
    }
    
    struct ViewState: Equatable {
        static func == (lhs: AlbumListViewModel.ViewState, rhs: AlbumListViewModel.ViewState) -> Bool {
            lhs.albums == rhs.albums &&
            lhs.filteredAlbums == rhs.filteredAlbums &&
            lhs.query == rhs.query &&
            lhs.isLoading == rhs.isLoading &&
            lhs.title == rhs.title
        }
        
        var albums: [MusicAlbum]
        var filteredAlbums: [MusicAlbum]
        var query: String
        var isLoading: Bool
        var title: String
        var sortClosure: (MusicAlbum, MusicAlbum) -> Bool
        
        static func initialState(for title: String,
                                 sorting: @escaping (MusicAlbum, MusicAlbum) -> Bool) ->  ViewState {
            ViewState(albums: [],
                      filteredAlbums: [],
                      query: "",
                      isLoading: false,
                      title: title,
                      sortClosure: sorting)
        }
        
        static func fromAppState(_ state: AppState,
                                 title: String,
                                 sort: @escaping (MusicAlbum, MusicAlbum) -> Bool) -> ViewState {
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
            
            albums.sort(by: sort)
            
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
                             title: title,
                             sortClosure: sort)
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
