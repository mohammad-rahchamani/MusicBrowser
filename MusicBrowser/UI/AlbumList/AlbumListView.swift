//
//  AlbumListView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import SwiftRex
import CombineRex

struct AlbumListView: View {
    
    @ObservedObject var viewModel: ObservableViewModel<AlbumListViewModel.ViewAction, AlbumListViewModel.ViewState>
    
    var isLoading: Bool {
        viewModel.state.isLoading
    }
    
    var albums: [MusicAlbum] {
        viewModel.state.filteredAlbums
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
        NavigationView {
            Group {
                if isLoading {
                    loadingView
                } else {
                    contentView
                }
            }
            .searchable(text: $viewModel.state.query)
            .navigationTitle("Music Browser")
            .onChange(of: viewModel.state.query) { query in
                viewModel.dispatch(.filter(query))
            }
        }.onAppear {
            viewModel.dispatch(.show)
        }
    }
}
