//
//  DashboardView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import CombineRex

struct DashboardView: View {
    
    @ObservedObject var viewModel: ObservableViewModel<DashboardViewModel.ViewAction, DashboardViewModel.ViewState>
    
    let albumPage: () -> AnyView
    let trackPage: () -> AnyView
    
    init(viewModel: ObservableViewModel<DashboardViewModel.ViewAction, DashboardViewModel.ViewState>,
         albumPage: @escaping () -> AnyView,
         trackPage: @escaping () -> AnyView) {
        self.viewModel = viewModel
        self.albumPage = albumPage
        self.trackPage = trackPage
    }
    
    var body: some View {
//        TabView(selection: $viewModel.state.selectedTab) {
        TabView(selection: $viewModel.state.selectedTab) {
            albumPage()
                .tabItem({ Text ("Albums")})
                .tag(TabState.album)
            
            trackPage()
//            AlbumListView(viewModel: AlbumListViewModel.viewModel(from: store))
                .tabItem({ Text ("Tracks")})
                .tag(TabState.track)
        }
        .onChange(of: viewModel.state.selectedTab) { tab in
            print("send select \(tab) action")
            viewModel.dispatch(.select(tab))
        }
    }
}

