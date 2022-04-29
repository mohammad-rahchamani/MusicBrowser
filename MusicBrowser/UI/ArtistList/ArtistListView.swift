//
//  ArtistListView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import CombineRex

struct ArtistListView<ListItem: View>: View {
    
    @ObservedObject var viewModel: ObservableViewModel<ArtistListViewModel.ViewAction, ArtistListViewModel.ViewState>
    
    let itemRendered: (String) -> ListItem
    
    init(viewModel: ObservableViewModel<ArtistListViewModel.ViewAction, ArtistListViewModel.ViewState>,
         itemRendered: @escaping (String) -> ListItem) {
        self.viewModel = viewModel
        self.itemRendered = itemRendered
    }
    
    var isLoading: Bool {
        viewModel.state.isLoading
    }
    
    var artists: [String] {
        viewModel.state.filteredArtists
    }
    
    @ViewBuilder
    var loadingView: some View {
        Text("loading")
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            List(artists) { artist in
                self.itemRendered(artist)
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
            .navigationTitle(viewModel.state.title)
            .onChange(of: viewModel.state.query) { query in
                viewModel.dispatch(.filter(query))
            }
        }
    }
}
