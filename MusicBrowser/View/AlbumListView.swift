//
//  AlbumListView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI

enum AlbumListViewModel {
    
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
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView()
    }
}
