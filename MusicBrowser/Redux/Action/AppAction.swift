//
//  AppAction.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation

enum AppAction: Equatable {
    case load(LoadAction)
    case filter(FilterAction)
    case tab(TabAction)
}
