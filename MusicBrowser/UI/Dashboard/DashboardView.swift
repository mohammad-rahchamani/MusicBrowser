//
//  DashboardView.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import SwiftUI
import CombineRex

struct DashboardView<FirstTab: View, SecondTab: View, ThirdTab: View>: View {
    
    @ObservedObject var viewModel: ObservableViewModel<DashboardViewModel.ViewAction, DashboardViewModel.ViewState>
    
    let albumPage: () -> FirstTab
    let artistPage: () -> SecondTab
    let trackPage: () -> ThirdTab
    
    init(viewModel: ObservableViewModel<DashboardViewModel.ViewAction, DashboardViewModel.ViewState>,
         albumPage: @escaping () -> FirstTab,
         artistPage: @escaping () -> SecondTab,
         trackPage: @escaping () -> ThirdTab) {
        self.viewModel = viewModel
        self.albumPage = albumPage
        self.artistPage = artistPage
        self.trackPage = trackPage
    }
    
    var body: some View {
        TabView(selection: $viewModel.state.selectedTab) {
            albumPage()
                .tabItem({ Text ("Albums")})
                .tag(TabState.album)
            artistPage()
                .tabItem({ Text ("Artists")})
                .tag(TabState.artist)
            trackPage()
                .tabItem({ Text ("Tracks")})
                .tag(TabState.track)
        }
        .onChange(of: viewModel.state.selectedTab) { tab in
            viewModel.dispatch(.select(tab))
        }
    }
}

