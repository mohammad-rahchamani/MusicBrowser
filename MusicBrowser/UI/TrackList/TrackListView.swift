//
//  TrackListView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import CombineRex

struct TrackListView<ListItem: View>: View {
    
    @ObservedObject var viewModel: ObservableViewModel<TrackListViewModel.ViewAction, TrackListViewModel.ViewState>
    
    let itemRendered: (String) -> ListItem
    
    init(viewModel: ObservableViewModel<TrackListViewModel.ViewAction, TrackListViewModel.ViewState>,
         itemRendered: @escaping (String) -> ListItem) {
        self.viewModel = viewModel
        self.itemRendered = itemRendered
    }
    
    var isLoading: Bool {
        viewModel.state.isLoading
    }
    
    var tracks: [String] {
        viewModel.state.filteredTracks
    }
    
    @ViewBuilder
    var loadingView: some View {
        Text("loading")
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            List(tracks) { album in
                self.itemRendered(album)
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
