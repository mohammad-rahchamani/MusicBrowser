//
//  MusicLoader.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/28/22.
//

import Foundation
import Combine

public final class MusicLoader {
    
    private let session: URLSession
    private let url: URL
    
    public init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }
    
    public func load() -> AnyPublisher<[MusicAlbum], Error> {
        session.dataTaskPublisher(for: self.url)
            .map(\.data)
            .decode(type: [MusicAlbum].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
