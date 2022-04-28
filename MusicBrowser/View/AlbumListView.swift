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
            switch state.albums {
            case .loading:
                return ViewState(albums: [], isLoading: true)
            case .neverLoaded:
                return ViewState(albums: [], isLoading: false)
            case .loaded(let albums):
                return ViewState(albums: albums, isLoading: false)
                
            }
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
