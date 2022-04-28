//
//  AlbumLoaderMiddleware.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/29/22.
//

import Foundation
import SwiftRex
import Combine

class AlbumLoaderMiddleware: MiddlewareProtocol {
    
    typealias InputActionType = LoadAction
    
    typealias OutputActionType = LoadAction
    
    typealias StateType = Void
    
    private let albumLoader: AnyPublisher<[MusicAlbum], Error>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(albumLoader: AnyPublisher<[MusicAlbum], Error>) {
        self.albumLoader = albumLoader
    }
    
    func handle(action: LoadAction,
                from dispatcher: ActionSource,
                state: @escaping GetState<Void>) -> IO<LoadAction> {
        if .startLoading != action { return .pure() }
        return IO { [weak self] output in
            guard let self = self else { return }
            self.albumLoader
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        output.dispatch(.loadFailed)
                    }
                }, receiveValue: { value in
                    output.dispatch(.loadEnded(value))
                }).store(in: &self.cancellables)
        }
    }
    
}
