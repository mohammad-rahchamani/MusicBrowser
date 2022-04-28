//
//  AlbumListView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import SwiftRex
import CombineRex

enum AlbumListViewModel {
    
    static func viewModel<S: StoreType>(from store: S) -> ObservableViewModel<ViewAction, ViewState> where S.ActionType == AppAction, S.StateType == AppState {
        store.projection(action: ViewAction.toAppAction(_:),
                         state: ViewState.fromAppState(_:))
            .asObservableViewModel(initialState: .initialState)
    }
    
    struct ViewState: Equatable {
        var albums: [MusicAlbum]
        var isLoading: Bool
        
        static var initialState: ViewState {
            ViewState(albums: [], isLoading: false)
        }
        
        static func fromAppState(_ state: AppState) -> ViewState {
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
            return ViewState(albums: albums, isLoading: isLoading)
        }
    }
    
    enum ViewAction: Equatable {
        case show
        
        static func toAppAction(_ action: ViewAction) -> AppAction {
            .load(.startLoading)
        }
        
    }
    
}

struct AlbumListView: View {
    
    @ObservedObject var viewModel: ObservableViewModel<AlbumListViewModel.ViewAction, AlbumListViewModel.ViewState>
    
    @State var searchText: String = ""
    
    var isLoading: Bool {
        viewModel.state.isLoading
    }
    
    var albums: [MusicAlbum] {
        viewModel.state.albums
    }
    
    @ViewBuilder
    var loadingView: some View {
        Text("loading")
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            List(albums) { album in
                Text(album.album)
            }
        }
    }
    
    var body: some View {
        Group {
            if isLoading {
                loadingView
            } else {
                contentView
            }
        }.onAppear {
            viewModel.dispatch(.show)
        }
    }
}

//struct AlbumListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumListView()
//    }
//}
