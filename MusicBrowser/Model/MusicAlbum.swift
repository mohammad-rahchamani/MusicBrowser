//
//  MusicAlbum.swift
//  MusicBrowser
//
//  Created by Mohammad Rahchamani on 4/28/22.
//

import Foundation

public struct MusicAlbum: Equatable, Codable {
    public init(id: String, album: String, artist: String, cover: String, label: String, tracks: [String], year: String) {
        self.id = id
        self.album = album
        self.artist = artist
        self.cover = cover
        self.label = label
        self.tracks = tracks
        self.year = year
    }
    
    public let id: String
    public let album: String
    public let artist: String
    public let cover: String
    public let label: String
    public let tracks: [String]
    public let year: String
}
